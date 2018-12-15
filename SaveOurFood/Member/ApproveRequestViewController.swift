//
//  ApproveRequestViewController.swift
//  SaveOurFood
//
//  Created by Aniket Kalkar on 14/12/18.
//  Copyright © 2018 Shreyas Kalyanaraman. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase

class ApproveRequestViewController: UIViewController {

    
    @IBOutlet weak var requestImage: UIImageView!
    
    @IBOutlet weak var Timestamp: UILabel!
    
    @IBOutlet weak var textBox: UITextView!
    
    var requestDetails:FoodItemRequest?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func approveRequest(_ sender: Any) {
        
        let databaseRef = Database.database().reference().child("Boston/"+(requestDetails?.getRequestId())!)
        
        databaseRef.updateChildValues([
            "status":"Pickup confirmed"
        ])
        
        let alert = UIAlertController(title: "Success", message: "Pickup accepted successfully", preferredStyle:UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style:UIAlertAction.Style.default, handler: nil))
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