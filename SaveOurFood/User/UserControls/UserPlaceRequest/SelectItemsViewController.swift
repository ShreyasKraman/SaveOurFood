//
//  SelectItemsViewController.swift
//  SaveOurFood
//
//  Created by Aniket Kalkar on 12/12/18.
//  Copyright © 2018 Shreyas Kalyanaraman. All rights reserved.
//

import UIKit

class SelectItemsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var foodItem:[FoodItems]?
    var selectedFoodItems:[FoodItems]?
    
    @IBOutlet weak var itemsTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        foodItem = [
            FoodItems(name: "cooked Vegetable", image: "cooked_veggies.jpg"),
            FoodItems(name: "raw Vegetable", image: "raw_veggies.jpg"),
            FoodItems(name: "cooked meat", image: "cooked_meat.jpg"),
            FoodItems(name: "uncooked meat", image: "raw_meat.jpeg"),
            FoodItems(name: "cooked poultry", image: "cooked_poultry.jpg"),
            FoodItems(name: "raw poultry", image: "raw_poultry.jpg")
        ]
        self.selectedFoodItems = []
        
        itemsTable.dataSource = self
        itemsTable.delegate = self
        itemsTable.allowsMultipleSelection = true
        
        let rightButtonItem = UIBarButtonItem.init(
            title: "Confirm",
            style: .done,
            target: self,
            action: #selector(confirmPickUp(sender:))
        )
        
        self.navigationItem.rightBarButtonItem = rightButtonItem
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foodItem!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.itemsTable.dequeueReusableCell(withIdentifier: "reuseCell")!
        
        let text = foodItem![indexPath.row]
        cell.textLabel?.text = text.getName()
        cell.imageView?.image = UIImage(named: text.getImage())
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = self.itemsTable.cellForRow(at: indexPath) {
            if cell.isSelected {
                cell.accessoryType = .checkmark
                tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
            }
        }
        
        self.selectedFoodItems?.append(foodItem![indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = self.itemsTable.cellForRow(at: indexPath){
            cell.accessoryType = .none
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
        var pos = 0
        for i in selectedFoodItems!{
            if i.getName() == foodItem![indexPath.row].getName(){
                break;
            }
            pos = pos + 1
        }
        
        self.selectedFoodItems?.remove(at: pos)
    }
    
    @objc func confirmPickUp(sender:UIBarButtonItem) {
        
            var itemsSelected:String = ""
        for i in self.selectedFoodItems!{
                itemsSelected = itemsSelected + i.getName() + ", "
            }

        
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let confirmPickup = storyBoard.instantiateViewController(withIdentifier: "ConfirmPickUpViewController") as! ConfirmPickUpViewController
        
         confirmPickup.textData = itemsSelected
        
        self.navigationController?.pushViewController(confirmPickup, animated: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        foodItem = searchText.isEmpty ?  foodItem : foodItem!.filter{(food:FoodItems) -> Bool in
            return food.getName().range(of: searchText, options: .caseInsensitive, range:nil, locale:nil) != nil
        }
        
        itemsTable.reloadData()
    }
    
    private func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle{
        return .none
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
