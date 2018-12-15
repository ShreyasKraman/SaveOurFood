//
//  MemberRegisterationViewController.swift
//  SaveOurFood
//
//  Created by Aniket Kalkar on 14/12/18.
//  Copyright © 2018 Shreyas Kalyanaraman. All rights reserved.
//

import UIKit
import Foundation
import FirebaseDatabase
import FirebaseStorage


class MemberRegisterationViewController: UIViewController {

    @IBOutlet weak var nameLabel: UITextField!
    
    
    @IBOutlet weak var addressLabel: UITextField!
    
    @IBOutlet weak var phoneLabel: UITextField!
    
    @IBOutlet weak var zipLabel: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var confirmPassword: UITextField!
    
    @IBOutlet weak var username: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
    @IBAction func registerMember(_ sender: Any) {
        
        if (nameLabel.text != nil && nameLabel.text != "")
        || (addressLabel.text != nil && addressLabel.text != "")
        || (phoneLabel.text != nil && phoneLabel.text != "")
        || (zipLabel.text != nil && zipLabel.text != "")
        || (username.text != nil && username.text != "")
        || (password.text != nil && password.text != "")
        || (confirmPassword.text != nil && confirmPassword.text != "") {
            
            let name = nameLabel.text
            if name!.count < 10{
                showErrorAlert(message: "Length of name should be greater than 10 chars")
                return
            }
            let address = addressLabel.text
            if address!.count < 10{
                showErrorAlert(message: "Length of address should be greater than 10 chars")
                return
            }
            let phone = phoneLabel.text
            if phone!.count < 10 || phone!.count > 10{
                showErrorAlert(message: "Length of phone should not be greater than 10 chars")
                return
            }
            let useremail = username.text
            if useremail!.count < 10 || useremail!.range(of: "\\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,}\\b.", options: .regularExpression, range: nil, locale: nil) != nil{
                showErrorAlert(message: "Email should atleast be of 10 characters and must be valid")
                return
            }
            
            let pass = password.text
            let cpass = confirmPassword.text
            
            if pass != cpass{
                showErrorAlert(message: "Password and confirm password do no match")
                return
            }
            
            let date = Date()
            let calendar = Calendar.current
            let components = calendar.dateComponents([.year,.month,.day,.second,.minute,.hour,.weekday], from: date)
            let dateRequested = String(components.month!) + "/" + String(components.day!) + "/" + String(components.year!)
            

            let datarefer = Database.database().reference().child("AccountRequest")
            
            let key = datarefer.childByAutoId().key
            
            let accountRequest = [
                "id":key,
                "name":name,
                "address":address,
                "phone":phone,
                "zip":(zipLabel!.text as! String),
                "date":dateRequested,
                "username":useremail,
                "password":pass,
                "status":"0"
            ]
            
            datarefer.child(key!).setValue(accountRequest)
            
            let alert = UIAlertController(title: "Success", message: "Request submitted successfully", preferredStyle:UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style:UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            //Dismiss view to login
            dismiss(animated: true, completion: nil)
        }else{
            showErrorAlert(message: "All the fields are mandatory. Please fill all of them")
        }

        
    }
    
    func showErrorAlert(message:String){
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle:UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style:UIAlertAction.Style.destructive, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        
    }

    
    @IBAction func signIn(_ sender: Any) {
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
