//
//  ManageAccountViewController.swift
//  SaveOurFood
//
//  Created by Aniket Kalkar on 14/12/18.
//  Copyright © 2018 Shreyas Kalyanaraman. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage


class ManageCustomCell:UITableViewCell{
    
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var viewDocument: UIButton!
    
}


class ManageAccountViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var accounts = [OrganizationAccount]()
    var selectedAccounts = [OrganizationAccount]()
    
    
    @IBOutlet weak var accountsTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let databaseReferrer = Database.database().reference().child("AccountRequest")
        
        databaseReferrer.observe(.value, with: {(snapshot) in
            
            if snapshot.childrenCount > 0{
            
                self.accounts.removeAll()
                
                for items in snapshot.children.allObjects as! [DataSnapshot]{
                    let itemObject = items.value as? [String:AnyObject]
                    
                    let id = itemObject?["id"] as! String
                    let name = itemObject?["name"] as! String
                    let address = itemObject?["address"] as! String
                    let phone = itemObject?["phone"] as! String
                    let zip = itemObject?["zip"] as! String
                    let status = itemObject?["status"] as! String
                    //let docURL = itemObject?["url"] as! String
                    let requestDate = itemObject?["date"] as! String
                    //Retreive image
//                    let storageRef = Storage.storage().reference(forURL: docURL as! String)
//
//                    storageRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) -> Void in
//                        // Create a UIImage, add it to the array
//                    let pic = UIImage(data: data!)
                    
                    do{
                        let orgAc = try OrganizationAccount(id:id,name: name, address: address, phone: phone, zip: zip, certi: "", email: "", password: "", status: status, date:requestDate)
                        self.accounts.append(orgAc)
                    }catch{
                        self.showErrorAlert(message: "Error while retriving data")
                    }
                    //                        }
                    
                }
                DispatchQueue.main.async {
                    self.accountsTable.reloadData()
                }
            }
            
        })
        
        accountsTable.delegate = self
        accountsTable.dataSource = self
        
        
        let rightButtonItem = UIBarButtonItem.init(
            title: "Approve",
            style: .done,
            target: self,
            action: #selector(approveAccounts(sender:))
        )
        
        self.navigationItem.rightBarButtonItem = rightButtonItem
        
        accountsTable.allowsMultipleSelection = true
        
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accounts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseCell") as! ManageCustomCell
        
        let account = accounts[indexPath.row]
        
        cell.dateLabel.text = account.getDate()
        
        cell.nameLabel.text = account.getName()
        
        if account.getStatus() == "0"{
            cell.statusLabel.text = "Pending"
            cell.statusLabel.textColor = UIColor.red
        }else if account.getStatus() == "1"{
            cell.statusLabel.text = "Approved"
            cell.statusLabel.textColor = UIColor.green
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = self.accountsTable.cellForRow(at: indexPath) {
            if cell.isSelected {
                cell.accessoryType = .checkmark
                tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
            }
        }
        
        self.selectedAccounts.append(accounts[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = self.accountsTable.cellForRow(at: indexPath){
            cell.accessoryType = .none
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
        var pos = 0
        for i in accounts{
            if i.getName() == accounts[indexPath.row].getName(){
                break;
            }
            pos = pos + 1
        }
        
        self.selectedAccounts.remove(at: pos)
    }
    
    @objc func approveAccounts(sender:UIBarButtonItem){
        
        let alert = UIAlertController(title: "Alert", message: "Are you sure you want to approve selected requests?", preferredStyle:UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Yes", style:.default, handler: { action in
            switch action.style{
            case .default:
                self.approve(selectedAccounts : self.selectedAccounts)
            case .cancel:
                break
            case .destructive:
                break
            }}))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func approve(selectedAccounts :[OrganizationAccount]){
        
        
        for accounts in selectedAccounts{
            
            
            let databaseReferrer = Database.database().reference().child("AccountRequest/"+accounts.getId())
            
            databaseReferrer.updateChildValues([
                "status":"1"
            ])
            
            
        
        }
        
    }
    
    
    @IBAction func viewDocument(_ sender: UIButton) {
        
        let cell = sender.superview?.superview as! CustomCell
        let indexPath = accountsTable.indexPath(for: cell)
        
        if(accounts[indexPath!.row].getCertificate() != nil){
            UIApplication.shared.canOpenURL(URL(fileURLWithPath: accounts[indexPath!.row].getCertificate()))
        }else{
            showErrorAlert(message: "Document could not be opened")
        }
    }
    
    func showErrorAlert(message:String){
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle:UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style:UIAlertAction.Style.destructive, handler: nil))
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
