//
//  FoodItemRequest.swift
//  SaveOurFood
//
//  Created by Aniket Kalkar on 14/12/18.
//  Copyright © 2018 Shreyas Kalyanaraman. All rights reserved.
//

import Foundation
import UIKit

class FoodItemRequest{
    
    var requestId:String?
    var data:String?
    var image:UIImage?
    var date:String?
    var time:String?
    var day:String?
    var status:String?
    
    init(id: String, date:String,time:String,day:String, items:String, image:UIImage, status:String) {
        requestId = id
        self.date = date
        self.time = time
        self.day = day
        self.data = items
        self.image = image
        self.status = status
    }
    
    func getRequestId() -> String{
        return requestId!
    }
    
    func getdate() -> String{
        return date!
    }
    func getTime() -> String{
        return time!
    }
    func getday() -> String{
        return day!
    }
    func getData() -> String{
        return data!
    }
    func getImage() -> UIImage{
        return image!
    }
    
    func getStatus() -> String{
        return status!
    }

}
