//
//  MemberAccountViewController.swift
//  SaveOurFood
//
//  Created by Aniket Kalkar on 14/12/18.
//  Copyright © 2018 Shreyas Kalyanaraman. All rights reserved.
//

import UIKit
import FirebaseDatabase


class MemberAccountViewController: UIViewController {

    @IBOutlet weak var oldPassword: UITextField!
    
    @IBOutlet weak var newPassword: UITextField!
    
    @IBOutlet weak var confirmPassword: UITextField!
    
    var org:OrganizationAccount?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let rightButtonItem = UIBarButtonItem.init(
            title: "Signout",
            style: .done,
            target: self,
            action: #selector(logOutUser(sender:))
        )
        
        self.navigationItem.rightBarButtonItem = rightButtonItem
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @objc func logOutUser(sender:UIBarButtonItem){
        dismiss(animated: true, completion: nil)
    }

    @IBAction func changePassword(_ sender: Any) {
        
        let datareferrer = Database.database().reference().child("AccountRequest")
        
        var id = "0"
        datareferrer.observe(.value, with: {(snapshot) in
            
            if snapshot.childrenCount > 0{
                
                let email = self.org?.getEmailAddress()
                
                for account in snapshot.children.allObjects as! [DataSnapshot]{
                    let accountObject = account.value as? [String:AnyObject]
                    
                    let emailAddress = accountObject?["username"] as! String
                    
                    if emailAddress == email{
                        let pass = accountObject?["password"] as! String
                        
                        if pass == self.oldPassword.text{
                            let status = accountObject?["status"] as! String
                            if status != "1"{
                                self.showErrorAlert(message: "Your account has not been approved")
                            }else if status == "1"{
                                id = accountObject?["id"] as! String
                                
                                if self.confirmPassword.text == self.newPassword.text{
                                    
                                    let dataref = Database.database().reference().child("AccountRequest/"+id)
                                    
                                    dataref.updateChildValues([
                                        "password":self.confirmPassword.text
                                    ])
                                    
                                }else{
                                    self.showErrorAlert(message: "password do not match")
                                }
                                break
                            }
                        }else{
                            self.showErrorAlert(message: "Username or password is in valid")
                        }
                        
                    }
                    
                }
            }
            
        })
        
        
    }
    
    func showErrorAlert(message:String){
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle:UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style:UIAlertAction.Style.destructive, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        
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
