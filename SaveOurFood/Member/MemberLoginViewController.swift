//
//  MemberLoginViewController.swift
//  SaveOurFood
//
//  Created by Aniket Kalkar on 14/12/18.
//  Copyright © 2018 Shreyas Kalyanaraman. All rights reserved.
//

import UIKit
import FirebaseDatabase


class MemberLoginViewController: UIViewController {

    @IBOutlet weak var username: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    
        // Do any additional setup after loading the view.
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @IBAction func loginAction(_ sender: Any) {
        
        if username.text?.range(of: "[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,}", options: .regularExpression, range: nil, locale: nil) != nil{
            showErrorAlert(message: "Username must be in valid email format")
            return
        }
        
        
        if username.text == "admin" && password.text == "admin"{
            
            if let tabbar = (storyboard!.instantiateViewController(withIdentifier: "admintabbar") as? AdminTabBarViewController) {
                self.present(tabbar, animated: true, completion: nil)
            }
            
        }else{
            
            
            var name = ""
            var phone = ""
            var zip = ""
            var address = ""
            
            let datareferrer = Database.database().reference().child("AccountRequest")
            
            var id = "0"
            datareferrer.observe(.value, with: {(snapshot) in
                
                if snapshot.childrenCount > 0{
                    
                    let email = self.username!.text
                    var flag = 0
                    for account in snapshot.children.allObjects as! [DataSnapshot]{
                        let accountObject = account.value as? [String:AnyObject]
                        
                        let emailAddress = accountObject?["username"] as! String
                        
                        if emailAddress == email{
                            let pass = accountObject?["password"] as! String
                            
                            if pass == self.password.text{
                                let status = accountObject?["status"] as! String
                                if status != "1"{
                                    self.showErrorAlert(message: "Your account has not been approved")
                                }else if status == "1"{
                                    id = accountObject?["id"] as! String
                                    name = accountObject?["name"] as! String
                                    address = accountObject?["address"] as! String
                                    phone = accountObject?["phone"] as! String
                                    zip = accountObject?["zip"] as! String
                                    flag = 1
                                    break
                                }
                            }
                            
                        }

                    }
                    
                    if(flag == 0){
                        self.showErrorAlert(message: "Username password Invalid")
                    }
                    
                    let org = OrganizationAccount(id: id, name: name, address: address, phone: phone, zip: zip, certi: "", email: self.username.text!, password: self.password.text!, status: "1", date: "")
                    
                    let tabbar = (self.storyboard!.instantiateViewController(withIdentifier: "ngoTabBar") as? UITabBarController)
                    
                    let navigate = tabbar!.viewControllers?.first as! UINavigationController
                    let memberRequest =  navigate.viewControllers.first as! MemberRequestViewController
                    
                    memberRequest.org = org
                    
                    let navigate1 = tabbar!.viewControllers?[1] as! UINavigationController
                    let memberAccount =  navigate1.viewControllers.first as! MemberAccountViewController
                    memberAccount.org = org
                    
                    self.present(tabbar!,animated: true)
                
                }
                
            })
            
//            if id != "0" && id != ""{
//
//                let org = OrganizationAccount(id: id, name: name, address: address, phone: phone, zip: zip, certi: "", email: username.text!, password: "", status: "1", date: "")
//
//                let tabbar = (storyboard!.instantiateViewController(withIdentifier: "ngoTabBar") as? UITabBarController)
//
//                let navigate = tabbar!.viewControllers?.first as! MemberNavigationController
//                let memberRequest =  navigate.viewControllers.first as! MemberRequestViewController
//
//                memberRequest.org = org
//
//                self.present(tabbar!,animated: true)
//
           // }
            
        }
        
    }
    
    func showErrorAlert(message:String){
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle:UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style:UIAlertAction.Style.destructive, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
