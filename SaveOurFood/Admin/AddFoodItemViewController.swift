//
//  AccountRequestViewController.swift
//  SaveOurFood
//
//  Created by Aniket Kalkar on 14/12/18.
//  Copyright © 2018 Shreyas Kalyanaraman. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage

class AddFoodItemViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var foodItems = [FoodItems]()

    @IBOutlet weak var foodTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        foodTable.delegate = self
        foodTable.dataSource = self
        
        let databaseReferrer = Database.database().reference().child("FoodItems")
        
        databaseReferrer.observe(.value, with: {(snapshot) in
            
            if snapshot.childrenCount > 0{
                
                self.foodItems.removeAll()
                
                for items in snapshot.children.allObjects as! [DataSnapshot]{
                    let itemObject = items.value as? [String:AnyObject]
                    
                    let id = itemObject?["id"] as! String
                    let name = itemObject?["item"] as! String
                    let imageURL = itemObject?["image"] as! String
                    
                    //Retreive image
                    if imageURL != nil && imageURL != ""{
                        let storageRef = Storage.storage().reference(forURL: imageURL as! String)
                        
                        storageRef.getData(maxSize: 5 * 1024 * 1024) { (data, error) -> Void in
                                                // Create a UIImage, add it to the array
                            let pic = UIImage(data: data!)
                            
                            let foodItem = FoodItems(name: name, image: pic!)
                            
                            self.foodItems.append(foodItem)
                            
                            DispatchQueue.main.async {
                                self.foodTable.reloadData()
                            }
                        }
                    }
                }
                
            }
            
        })
        
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return foodItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseCell")
        
        let food = foodItems[indexPath.row]

        cell?.imageView?.image = food.getImage()
        cell?.textLabel?.text = food.getName()
        
        return cell!
        
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
