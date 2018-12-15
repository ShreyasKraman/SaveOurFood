//
//  OrganizationAccount.swift
//  SaveOurFood
//
//  Created by Aniket Kalkar on 14/12/18.
//  Copyright © 2018 Shreyas Kalyanaraman. All rights reserved.
//

import Foundation

class OrganizationAccount{
    
    var id:String?
    var name:String?
    var address:String?
    var phone:String?
    var zip:String?
    var certificate:String?
    var emailAddress:String?
    var password:String?
    var status:String?
    var date:String?
    
    init(id:String,name:String,address:String,phone:String,zip:String,certi:String,email:String,password:String,status:String, date:String){
        self.id = id
        self.name = name
        self.address = address
        self.phone = phone
        self.zip = zip
        self.certificate = certi
        self.emailAddress = email
        self.password = password
        self.status = status
        self.date = date
    }
    
    func getId() -> String{
        return self.id!
    }
    
    
    func getName()-> String{
        return self.name!
    }
    
    func getAddress() -> String{
        return self.address!
    }
    
    func getPhone() -> String{
        return self.phone!
    }
    
    func getZip() -> String{
        return self.zip!
    }
    
    func getCertificate() -> String{
        return certificate!
    }
    
    func getEmailAddress() -> String{
        return self.emailAddress!
    }
    
    func getPassword() -> String{
        return self.password!
    }
    
    func getStatus() -> String{
        return self.status!
    }
    
    func getDate() -> String{
        return self.date!
    }
    
}
