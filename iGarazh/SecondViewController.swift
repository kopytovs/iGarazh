//
//  SecondViewController.swift
//  iGarazh
//
//  Created by Sergey Kopytov on 05.10.16.
//  Copyright © 2016 Sergey Kopytov. All rights reserved.
//

import UIKit
import AVFoundation

class SecondViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    @IBOutlet weak var infoLabel: UILabel!
    
    var qrCodeFrameView: UIView?
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    
    var name: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        do{
            let input = try AVCaptureDeviceInput(device: captureDevice)
            captureSession = AVCaptureSession()
            captureSession?.addInput(input)
            
            qrCodeFrameView = UIView()
            
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)
            
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
            
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            view.layer.addSublayer(videoPreviewLayer!)
            
            captureSession?.startRunning()
            
            //optional for label
            //------------------
            view.bringSubview(toFront: infoLabel)
            
            if let qrCodeFrameView = qrCodeFrameView {
                
                qrCodeFrameView.layer.borderColor = UIColor.red.cgColor
                
                qrCodeFrameView.layer.borderWidth = 3
                
                view.addSubview(qrCodeFrameView)
                
                view.bringSubview(toFront: qrCodeFrameView)
                
                /*let vc = self.storyboard?.instantiateViewController(withIdentifier: "SID") as! MyPlaceTableViewController
                self.navigationController?.pushViewController(vc, animated: true)*/
                    //performSegue(withIdentifier: "TrueSegue", sender: self)
                //captureSession?.stopRunning()
                
            }
            
        } catch{
            print(error)
        }
        
        
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        
        if metadataObjects == nil || metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            infoLabel.text = "QR код не распознан!"
            
            return
        }
        
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
        
        qrCodeFrameView?.frame = (barCodeObject?.bounds)!
        
        if metadataObj.stringValue != nil {
            infoLabel.text = metadataObj.stringValue
            name = metadataObj.stringValue
            performSegue(withIdentifier: "TrueSegue", sender: self)
            
            captureSession?.stopRunning()
            
            /*let vco = UINavigationController(rootViewController: vc)
            
            self.present(vco, animated: true, completion: nil)*/
            
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationController = segue.destination as! MyPlaceTableViewController
        
        //print ("вот мой гребаный нейм: |\(name)|")

        destinationController.scaf = name
        
    }


}

