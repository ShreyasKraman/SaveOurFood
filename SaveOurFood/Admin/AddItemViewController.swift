//
//  AddItemViewController.swift
//  SaveOurFood
//
//  Created by Aniket Kalkar on 14/12/18.
//  Copyright © 2018 Shreyas Kalyanaraman. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage


class AddItemViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var itemName: UITextField!
    
    @IBOutlet weak var imageUpload: UIImageView!
    
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        imagePicker.delegate = self
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func browse(_ sender: UIButton) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        imagePicker.sourceType = .savedPhotosAlbum
        
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as?  UIImage{
            imageUpload.image = pickedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    

    @IBAction func AddItem(_ sender: Any) {
        
        let databaseReferer = Database.database().reference().child("FoodItems")
        
        let key = databaseReferer.childByAutoId().key
        
        let storage = Storage.storage()
        
        var data = Data()
        
        data = imageUpload.image!.pngData()!
        
        let storageRef = storage.reference()
        
        var downloadURL = ""
        
        let imageRef = storageRef.child(key!+".png")
        
        _ = imageRef.putData(data, metadata: nil, completion: {(metadata,error) in
            
            guard let metadata = metadata else{
                return
            }
            
            imageRef.downloadURL(completion: {(url, error) in
                
                guard let url = url else{
                    self.showErrorAlert(message: "Could not get image url")
                    return
                }
                
                downloadURL = url.absoluteString
                
                let foodData = [
                    "id":key,
                    "item":self.itemName.text!,
                    "image":downloadURL
                    //                "lat":self.latitude!,
                    //                "long":self.longiture!
                ]
                
                databaseReferer.child(key!).setValue(foodData)
                
                let alert = UIAlertController(title: "Success", message: "Value saved successfully", preferredStyle:UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style:UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            })
            
        })
        
        
        
//        imageRef.downloadURL(completion: {(url, error) in
//
//        guard let url = url else{
//            self.showErrorAlert(message: "Could not get image url")
//            return
//        }
//
//        downloadURL = url.absoluteString
//
//        })
        
        
        
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
