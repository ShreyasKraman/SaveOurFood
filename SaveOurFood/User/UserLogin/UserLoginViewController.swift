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
    
    var userDetails:User?
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error != nil{
            print(error ?? "google error")
            return
        }
        
        userDetails = User(email: user.profile.email, name: user.profile.name)
        
        guard let authentication = user.authentication else { return }
        
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        
        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
            if let error = error {
                print(error)
                return
            }
            
        }
        
        let tabbar = (storyboard!.instantiateViewController(withIdentifier: "tabbar") as? UITabBarController)
        
        let navigate = tabbar!.viewControllers?.first as! NavigationViewController
        let UserPlaceRequest =  navigate.viewControllers.first as! UserPlaceRequestViewController
        
        UserPlaceRequest.userDetails = userDetails!
        
        self.present(tabbar!,animated: true,completion: nil)
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.uiDelegate = self
        // Do any additional setup after loading the view.
    }
    
    @IBAction func googleLogin(_ sender: Any) {
        
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
