//
//  QRCodeViewController.swift
//  SaveOurFood
//
//  Created by Aniket Kalkar on 14/12/18.
//  Copyright © 2018 Shreyas Kalyanaraman. All rights reserved.
//

import UIKit

class QRCodeViewController: UIViewController {

    var id:String?
    
    @IBOutlet weak var qrcodeImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let image = generateQRCode(id: self.id!)
        qrcodeImage.image = image
        // Do any additional setup after loading the view.
    }
    

    func generateQRCode(id:String) ->UIImage?{
        let data = id.data(using: String.Encoding.isoLatin1, allowLossyConversion: false)
        if let filter = CIFilter(name: "CIQRCodeGenerator"){
            filter.setValue(data, forKey: "inputMessage")
            
            guard let qrcode = filter.outputImage else {return nil}
            let scaleX = qrcodeImage.frame.size.width / qrcode.extent.size.width
            let scaleY = qrcodeImage.frame.size.height / qrcode.extent.size.height
            let transform = CGAffineTransform(scaleX: scaleX, y: scaleY)
            if let output = filter.outputImage?.transformed(by: transform){
                return UIImage(ciImage: output)
            }
        }
        return nil
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
