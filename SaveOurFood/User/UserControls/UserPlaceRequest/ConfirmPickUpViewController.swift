//
//  ConfirmPickUpViewController.swift
//  SaveOurFood
//
//  Created by Aniket Kalkar on 12/12/18.
//  Copyright © 2018 Shreyas Kalyanaraman. All rights reserved.
//

import UIKit
import AVFoundation
import FirebaseDatabase
import FirebaseStorage
import CoreLocation

class ConfirmPickUpViewController: UIViewController,UINavigationControllerDelegate, UIImagePickerControllerDelegate,/* CLLocationManagerDelegate,*/ UIAlertViewDelegate{

    @IBOutlet weak var textBox: UITextView!
    var textData:String?
   
    @IBOutlet weak var photoImage: UIImageView!
    
    var imagePickerController : UIImagePickerController!
    
    var location:String?
    var latitude:String!
    var longiture:String!
    
    var databaseReferer:DatabaseReference!
    var databaseHandle:DatabaseHandle!
    
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var confirmButton: UIButton!
    
    var UserDetails:User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let textData = textData{
            textBox.text = textData
        }
       
//        locationManager.delegate = self
//        locationManager.requestWhenInUseAuthorization()
//
//        locationManager.requestLocation()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func didTapOnTakePhotoButton(_ sender: UIButton) {

        imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .camera
        present(imagePickerController, animated: true, completion: nil)

    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imagePickerController.dismiss(animated: true, completion: nil)
        photoImage.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
    }

//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        if let lat = locations.last?.coordinate.latitude, let long = locations.last?.coordinate.longitude {
//
//            lookUpCurrentLocation { geoLoc in
//                if let location = geoLoc?.locality {
//                    self.location = location
//                } else{
//                    self.showErrorAlert(message: "Location could not be determined.Please provide location permissions to confirm pickup")
//                }
//            }
//
//        } else {
//            self.showErrorAlert(message: "Location could not be determined. Please provide location permissions to confirm pickup")
//        }
//    }
    
//    func lookUpCurrentLocation(completionHandler: @escaping (CLPlacemark?) -> Void ) {
//        // Use the last reported location.
//        if let lastLocation = self.locationManager.location {
//            let geocoder = CLGeocoder()
//
//            // Look up the location and pass it to the completion handler
//            geocoder.reverseGeocodeLocation(lastLocation, completionHandler: { (placemarks, error) in
//                if error == nil {
//                    let firstLocation = placemarks?[0]
//                    completionHandler(firstLocation)
//                }
//                else {
//                    // An error occurred during geocoding.
//                    completionHandler(nil)
//                }
//            })
//        }
//        else {
//            // No location was available.
//            completionHandler(nil)
//        }
//    }
    
    func showErrorAlert(message:String){
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle:UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style:UIAlertAction.Style.destructive, handler: nil))
        self.present(alert, animated: true, completion: nil)
    
        
    }
    

    @IBAction func confirmRequest(_ sender: Any) {
        
        //Create Record in firebase
        
        let itemsData = textBox.text
        let image = photoImage.image
        let location = "Boston"//self.location
        let emailId = UserDetails?.getEmail()
        let name = UserDetails?.getName()
        
        if image == nil {
            showErrorAlert(message: "Please upload image")
            return
        }
        
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year,.month,.day,.second,.minute,.hour,.weekday], from: date)
        
        let requestDate = String(components.month!) + "/" + String(components.day!) + "/" + String(components.year!)
        let requestTime = String(components.hour!) + ":" + String(components.minute!) + ":" + String(components.second!)
        
        let day = String(components.weekday!)
        
        if(itemsData != nil /*|| image != nil || location != nil || longiture != nil || latitude != nil */){
        
            databaseReferer = Database.database().reference().child(location)
            
            let key = self.databaseReferer!.childByAutoId().key
            
            let storage = Storage.storage()

            var data = Data()

//            data = image!.jpegData(compressionQuality: 1.0)!
            
            data = image!.pngData()!
            
            let storageRef = storage.reference()

            var imageRef = storageRef.child(key!+".png")
//
            var downloadURL = ""
            
            _ = imageRef.putData(data, metadata: nil, completion: {(metadata,error) in

//                guard let metadata = metadata else{
//                    return
//                }

                imageRef.downloadURL(completion: {(url, error) in

                    guard let url = url else{
                        self.showErrorAlert(message: "Could not get image url")
                        return
                    }

                    downloadURL = url.absoluteString
                    
                    //let newKey = self.randomString(length: 13)
                    
                    let pickupData = [
                        "id":key,
                        "name":name,
                        "data":itemsData,
                        "emailId":emailId,
                        "image":downloadURL,
                        "date":requestDate,
                        "time":requestTime,
                        "day":day,
                        "status":"Pending",
                        "approver":""
                        //                "lat":self.latitude!,
                        //                "long":self.longiture!
                    ]

                    self.databaseReferer.child(key!).setValue(pickupData)

                    self.databaseReferer = Database.database().reference().child("Users")
                    
                    let keyUser = self.databaseReferer!.childByAutoId().key
                    
                    
                    let userRequestData = [
                        "id":keyUser,
                        "data":itemsData,
                        "emailId":emailId,
                        "image":downloadURL,
                        "date":requestDate,
                        "time":requestTime,
                        "day":day,
                        "status":"Pending"
                    ]
                    
                    self.databaseReferer.child(keyUser!).setValue(userRequestData)
                    
                    let alert = UIAlertController(title: "Success", message: "Pickup request placed successfully!", preferredStyle:UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style:UIAlertAction.Style.destructive, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
                })

            })
            
//            //Insert user record in database
//
//            let pickupData = [
//                "id":key,
//                "name":name,
//                "data":itemsData,
//                "emailId":emailId,
//                "image":downloadURL,
//                "date":requestDate,
//                "time":requestTime,
//                "day":day,
//                "status":"Pending",
//                "approver":""
//                //                "lat":self.latitude!,
//                //                "long":self.longiture!
//            ]
//
//            self.databaseReferer.child(key!).setValue(pickupData)
//
//
//            databaseReferer = Database.database().reference().child("Users")
//
//            let keyUser = self.databaseReferer!.childByAutoId().key
//
//
//            let userRequestData = [
//                "id":keyUser,
//                "data":itemsData,
//                "emailId":emailId,
//                "image":downloadURL,
//                "date":requestDate,
//                "time":requestTime,
//                "day":day,
//                "status":"Pending"
//            ]
//
//            self.databaseReferer.child(keyUser!).setValue(userRequestData)
//
//            let alert = UIAlertController(title: "Success", message: "Pickup request placed successfully!", preferredStyle:UIAlertController.Style.alert)
//            alert.addAction(UIAlertAction(title: "Ok", style:UIAlertAction.Style.destructive, handler: nil))
//            self.present(alert, animated: true, completion: nil)
            
        }else{
            showErrorAlert(message: "image, location are mandatory. Please upload the image or allow location access")
        }
        
    }
    
    func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0...length-1).map{ _ in letters.randomElement()! })
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
