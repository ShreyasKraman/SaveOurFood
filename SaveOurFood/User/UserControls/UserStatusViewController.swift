//
//  StatusViewController.swift
//  SaveOurFood
//
//  Created by Aniket Kalkar on 12/12/18.
//  Copyright © 2018 Shreyas Kalyanaraman. All rights reserved.
//

import UIKit
import GoogleSignIn

class UserStatusViewController: UIViewController {

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
    }
    

    @objc func logOutUser(sender:UIBarButtonItem){
        GIDSignIn.sharedInstance()?.signOut()
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
