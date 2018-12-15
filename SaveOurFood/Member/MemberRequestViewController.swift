//
//  MemberRequestViewController.swift
//  SaveOurFood
//
//  Created by Aniket Kalkar on 14/12/18.
//  Copyright © 2018 Shreyas Kalyanaraman. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage


class MemberRequestViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var org:OrganizationAccount?
    
    var requestDetails=[FoodItemRequest]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        let databaseReferrer = Database.database().reference().child("Boston")
        
        databaseReferrer.observe(.value, with: {(snapshot) in
            
            if snapshot.childrenCount > 0{
                
                
                self.requestDetails.removeAll()
                
                for items in snapshot.children.allObjects as! [DataSnapshot]{
                    let itemObject = items.value as? [String:AnyObject]
                    
                    let emailId = itemObject?["emailId"]
                    let itemsName = itemObject?["data"] as! String
                    let id = itemObject?["id"] as! String
                    let imageUrl = itemObject?["image"] as! String
                    let date = itemObject?["date"] as! String
                    let time = itemObject?["time"] as! String
                    let day = itemObject?["day"] as! String
                    let status = itemObject?["status"] as! String
                    let approver = itemObject?["approver"] as! String
                    
                    if ( approver != "" || approver == self.org?.getEmailAddress() ) && status != "Pending" {
                        continue
                    }
                    
                    //Retreive image
                    let storageRef = Storage.storage().reference(forURL: imageUrl as! String)
                    
                    storageRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) -> Void in
                                                // Create a UIImage, add it to the array
                        let pic = UIImage(data: data!)
                    
                        let foodItems = FoodItemRequest(id: id, date: date, time: time, day: day, items: itemsName, image: pic!,status: status, approver: "")
                        
                        self.requestDetails.append(foodItems)
                        
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                    
                }
                
            }
            
        })
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return requestDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "reuseCell")
        
        let request = requestDetails[indexPath.row]
        
        cell?.imageView!.image = request.getImage()
        
        cell?.textLabel!.text = request.getStatus() + " requested on: " + request.getdate()
        
        return cell!;
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let request = requestDetails[indexPath.row]
        
        
        
        

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
