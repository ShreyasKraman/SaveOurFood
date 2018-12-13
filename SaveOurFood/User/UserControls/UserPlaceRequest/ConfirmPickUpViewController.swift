//
//  ConfirmPickUpViewController.swift
//  SaveOurFood
//
//  Created by Aniket Kalkar on 12/12/18.
//  Copyright © 2018 Shreyas Kalyanaraman. All rights reserved.
//

import UIKit
import AVFoundation

class ConfirmPickUpViewController: UIViewController,UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var textBox: UITextView!
    var textData:String?
   
    @IBOutlet weak var photoImage: UIImageView!
    
    var imagePickerController : UIImagePickerController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let textData = textData{
            textBox.text = textData
        }
       
        
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


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
