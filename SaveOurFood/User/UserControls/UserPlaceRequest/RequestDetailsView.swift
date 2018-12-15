//
//  ViewController.swift
//  SaveOurFood
//
//  Created by Aniket Kalkar on 14/12/18.
//  Copyright © 2018 Shreyas Kalyanaraman. All rights reserved.
//

import UIKit

class RequestDetailsView: UIViewController {

    
    @IBOutlet weak var statusText: UILabel!
    
    @IBOutlet weak var itemImage: UIImageView!
    
    @IBOutlet weak var dateTime: UILabel!
    
    @IBOutlet weak var contentsView: UITextView!
    
    var id:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view
        
    }
    
    @IBAction func generateqrCode(_ sender: Any) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let generateqr = storyBoard.instantiateViewController(withIdentifier: "viewQR") as! QRCodeViewController
        
        generateqr.id = self.id
        
        self.navigationController?.pushViewController(generateqr, animated: true)
        
    
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
