//
//  ViewController.swift
//  SaveOurFood
//
//  Created by Aniket Kalkar on 12/12/18.
//  Copyright © 2018 Shreyas Kalyanaraman. All rights reserved.
//

import UIKit
import GoogleSignIn
import FirebaseDatabase
import FirebaseStorage


class CustomCell:UITableViewCell{
    
    @IBOutlet weak var orderNumberLabel: UILabel!
    
    
    @IBOutlet weak var itemsImageView: UIImageView!
    
    @IBOutlet weak var textBox: UITextView!

    @IBOutlet weak var statusLabel: UILabel!
}

class UserPlaceRequestViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var itemsTable: UITableView!
    
    var userDetails:User?
    
    var requestDetails = [FoodItemRequest]()
    
    var daysOfWeek = [
        1:"Sunday",
        2:"Monday",
        3:"Tuesday",
        4:"Wednesday",
        5:"Thursday",
        6:"Friday",
        7:"Saturday"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
//        foodItem = ["cooked vegetable","raw vegetale","cooked meat","uncooked meat","cooked poultry","uncooked poultry","left over eggs"]
        
        itemsTable.delegate = self
        itemsTable.dataSource = self
        
        let rightButtonItem = UIBarButtonItem.init(
            title: "+",
            style: .done,
            target: self,
            action: #selector(selectItems(sender:))
        )
        
        self.navigationItem.rightBarButtonItem = rightButtonItem
        
        let email = userDetails?.getEmail()
        
        if email != nil{
            
            let databaseReferrer = Database.database().reference().child("Users")
            
            databaseReferrer.observe(.value, with: {(snapshot) in
                
                if snapshot.childrenCount > 0{
                    
                    
                    self.requestDetails.removeAll()
                    
                    for items in snapshot.children.allObjects as! [DataSnapshot]{
                        let itemObject = items.value as? [String:AnyObject]
                        
                        let emailId = itemObject?["emailId"]
                        
                            if emailId == nil || emailId as! String != email{
                                continue
                            }
                        let itemsName = itemObject?["data"] as! String
                        let id = itemObject?["id"] as! String
                        let imageUrl = itemObject?["image"] as! String
                        let date = itemObject?["date"] as! String
                        let time = itemObject?["time"] as! String
                        let day = itemObject?["day"] as! String
                        let status = itemObject?["status"] as! String
                        
                        //Retreive image
//                        let storageRef = Storage.storage().reference(forURL: imageUrl as! String)
//
//                        storageRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) -> Void in
//                            // Create a UIImage, add it to the array
//                            let pic = UIImage(data: data!)
//
//
                        let foodItems = FoodItemRequest(id: id, date: date, time: time, day: day, items: itemsName, image: UIImage(named:"raw_meat.jpeg")!,status: status, approver: "")
                        
                            self.requestDetails.append(foodItems)
//                        }
                        
                    }
                    
                    DispatchQueue.main.async {
                        self.itemsTable.reloadData()
                    }
                    
                }
                
            })
            
        }
        
        if requestDetails != nil{
            print("IN here")
        }
        
    }
    
 
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return requestDetails.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = self.itemsTable.dequeueReusableCell(withIdentifier: "reuseCell") as! CustomCell
        
        let text = requestDetails[indexPath.row]
        
        cell.itemsImageView.image = text.getImage()
        cell.orderNumberLabel.text = text.getRequestId()
        cell.textBox.text = text.getData()
        
        if text.getStatus() == "Pending"{
            cell.statusLabel.text = "Awaiting pickup details"
            cell.statusLabel.textColor = UIColor.yellow
        }else if text.getStatus() == "Pickup confirmed"{
            cell.statusLabel.text = "volunteer on his way"
            cell.statusLabel.textColor = UIColor.lightGray
        }else if text.getStatus() == "Pickup completed"{
            cell.statusLabel.text = "Delivered"
            cell.statusLabel.textColor = UIColor.green
        }else{
            cell.statusLabel.text = "Cancelled"
            cell.statusLabel.textColor = UIColor.red
        }
        
        return cell

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let requestedItem = storyBoard.instantiateViewController(withIdentifier: "requestDetails") as! RequestDetailsView
        
        requestedItem.view.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: self.view.frame.height)

            let selectedRow = indexPath.row
            
            let requestItem = requestDetails[selectedRow]
            
            if requestItem.getStatus() == "Pending"{
                requestedItem.statusText.text = "Awaiting pickup details"
                requestedItem.statusText.textColor = UIColor.yellow
            }else if requestItem.getStatus() == "Pickup confirmed"{
                requestedItem.statusText.text = "volunteer on his way"
                requestedItem.statusText.textColor = UIColor.lightGray
            }else if requestItem.getStatus() == "Pickup completed"{
                requestedItem.statusText.text = "Delivered"
                requestedItem.statusText.textColor = UIColor.green
            }else{
                requestedItem.statusText.text = "Cancelled"
                requestedItem.statusText.textColor = UIColor.red
            }
            
            let day = daysOfWeek[Int(requestItem.getday())!]
            
            requestedItem.dateTime.text = "the " + day!
            requestedItem.dateTime.text = requestedItem.dateTime.text! + ", " + requestItem.getdate() + " at " + requestItem.getTime() + " hrs"
            
            requestedItem.contentsView.text = requestItem.getData()
            requestedItem.itemImage.image = requestItem.getImage()
        
            requestedItem.id = requestItem.getRequestId()
            
            self.navigationController?.pushViewController(requestedItem, animated: true)
            

    }

    @objc func selectItems(sender: UIBarButtonItem) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let selectItems = storyBoard.instantiateViewController(withIdentifier: "SelectItems") as! SelectItemsViewController
        
        selectItems.userDetails = self.userDetails
        
        self.navigationController?.pushViewController(selectItems, animated: true)
        
    }
    

    
}
