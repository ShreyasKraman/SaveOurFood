//
//  User.swift
//  SaveOurFood
//
//  Created by Aniket Kalkar on 13/12/18.
//  Copyright © 2018 Shreyas Kalyanaraman. All rights reserved.
//

import Foundation
class User{
    
    var emailId:String?
    var name:String?
    
    init(email:String, name:String){
        self.emailId = email
        self.name = name
    }
    
    func getName() -> String{
        return self.name!
    }
    
    func getEmail() -> String{
        return self.emailId!
    }
    
    
}
