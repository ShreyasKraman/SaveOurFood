//
//  UserLoginViewController.swift
//  SaveOurFood
//
//  Created by Aniket Kalkar on 11/12/18.
//  Copyright © 2018 Shreyas Kalyanaraman. All rights reserved.
//

import UIKit
import GoogleSignIn
import Firebase

class UserLoginViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate {
    @IBOutlet weak var loginButton: UIButton!
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error != nil{
            print(error ?? "google error")
            return
        }
        
        //if success display the email on label
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        
        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
            if let error = error {
                print(error)
                return
            }
            
            self.performSegue(withIdentifier: "googleSignIn", sender: self)
            
        }
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.uiDelegate = self
        // Do any additional setup after loading the view.
    }
    

    @IBAction func googleSignIn(_ sender: Any) {
        GIDSignIn.sharedInstance()?.signIn()
        
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
