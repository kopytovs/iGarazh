//
//  QRGenViewController.swift
//  iGarazh
//
//  Created by Sergey Kopytov on 16.11.16.
//  Copyright © 2016 Sergey Kopytov. All rights reserved.
//

import UIKit
import Photos

class QRGenViewController: UIViewController{

    @IBOutlet weak var QRImage: UIImageView!
    
    var name: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        QRImage.isUserInteractionEnabled = true
        
        //QRImage.image = nil
        
        print(name)
        if (!(name.isEmpty)){
            
            QRImage.image = generateQRCode(from: name)
            
            //UIImageWriteToSavedPhotosAlbum(QRImage.image!, self, nil, nil)
        }
        
        //sendMail(imageView: QRImage)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //UIImageWriteToSavedPhotosAlbum(QRImage.image!, self, nil, nil)
    }
    
    func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 100, y: 100)
            
            if let output = filter.outputImage?.applying(transform) {
                return UIImage(ciImage: output)
            }
        }
        
        return nil
    }
    
    @IBAction func Saving(_ sender: Any) {

        
        var image: UIImage = QRImage.image!
        
        image = image.resizeWith(width: 100)!
        
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        
        let saved = UIAlertController(title: "Успешно!", message: "Ваше изображение успешно сохранено в фотопленку", preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "ОК", style: .default, handler: {(alert) -> Void in})
        
        saved.addAction(ok)
        
        present(saved, animated: true, completion: nil)
        
        
    }
    
    func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    
    
    /*func image (image: image, didFinishSavingWithError: error, contextInfo: contextInfo){
        
    }*/
    
    
    
    /*func sendMail(imageView: UIImageView) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self;
            mail.setCcRecipients(["yyyy@xxx.com"])
            mail.setSubject("Your messagge")
            mail.setMessageBody("Message body", isHTML: false)
            let imageData: NSData = UIImagePNGRepresentation(imageView.image!)! as NSData
            mail.addAttachmentData(imageData as Data, mimeType: "image/png", fileName: "imageName")
            self.present(mail, animated: true, completion: nil)
    
    }*/
    
    /*func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }*/
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


extension UIImage {
    func resizeWith(percentage: CGFloat) -> UIImage? {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: size.width * percentage, height: size.height * percentage)))
        imageView.contentMode = .scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }
    func resizeWith(width: CGFloat) -> UIImage? {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))))
        imageView.contentMode = .scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }
}
