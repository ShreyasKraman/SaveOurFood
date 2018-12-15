//
//  AnalyticsViewController.swift
//  SaveOurFood
//
//  Created by Aniket Kalkar on 12/12/18.
//  Copyright © 2018 Shreyas Kalyanaraman. All rights reserved.
//

import UIKit
import GoogleSignIn
import Charts
import FirebaseDatabase

class UserAnalyticsViewController: UIViewController {

    @IBOutlet weak var barChartView: BarChartView!
    
    var foods=[String]()
    var data=[Double]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let rightButtonItem = UIBarButtonItem.init(
            title: "Signout",
            style: .done,
            target: self,
            action: #selector(logOutUser(sender:))
        )
        
        self.navigationItem.rightBarButtonItem = rightButtonItem
        
        let databaseReferrer = Database.database().reference().child("FoodItems")
        
        databaseReferrer.observe(.value, with: {(snapshot) in
            
            if snapshot.childrenCount > 0{
                
                self.foods.removeAll()
                
                for items in snapshot.children.allObjects as! [DataSnapshot]{
                    let itemObject = items.value as? [String:AnyObject]
                    let name = itemObject?["item"] as! String
                            
                    self.foods.append(name)
                    self.data.append(Double.random(in:20..<80))
                }
                
                self.setChart(dataPoints: self.foods, values: self.data)
                
            }
            
        })
        
    }
    
    func setChart(dataPoints: [String], values: [Double]){
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: values[i])
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "Types of Food Wastage")
        
        let chartData = BarChartData()
        chartData.addDataSet(chartDataSet)
        
        barChartView.data = chartData
        
        self.barChartView.gridBackgroundColor = NSUIColor.white
        
        self.barChartView.chartDescription?.text = "Annual count of food wastage type"
        
        self.barChartView.xAxis.setLabelCount(dataPoints.count, force: true)
        
        
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
