//
//  AdminAccountViewController.swift
//  SaveOurFood
//
//  Created by Aniket Kalkar on 14/12/18.
//  Copyright © 2018 Shreyas Kalyanaraman. All rights reserved.
//

import UIKit

class AdminAccountViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let rightButtonItem = UIBarButtonItem.init(
            title: "Signout",
            style: .done,
            target: self,
            action: #selector(logOutUser(sender:))
        )
        
        self.navigationItem.rightBarButtonItem = rightButtonItem
        
        // Do any additional setup after loading the view.
    }
    
    @objc func logOutUser(sender:UIBarButtonItem){
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
