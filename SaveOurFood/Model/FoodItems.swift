//
//  FoodItems.swift
//  SaveOurFood
//
//  Created by Aniket Kalkar on 12/12/18.
//  Copyright © 2018 Shreyas Kalyanaraman. All rights reserved.
//

import UIKit

class FoodItems{
    var itemName:String?
    var itemImage:UIImage?
    
    init(name:String,image:UIImage){
        itemName = name
        itemImage = image
    }
    
    func getName()->String{
        return self.itemName!
    }
    
    func getImage()->UIImage{
        return self.itemImage!
    }
    
    
}
