//
//  SettingsViewController.swift
//  iGarazh
//
//  Created by Sergey Kopytov on 15.11.16.
//  Copyright © 2016 Sergey Kopytov. All rights reserved.
//

import UIKit
import Photos
import MessageUI

class SettingsViewController: UIViewController, MFMailComposeViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "backgr"))

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendM(_ sender: Any) {
        
        sendEmail()
        
    }
    

    @IBAction func help(_ sender: Any) {
        
        let alert = UIAlertController(title: "Помощь", message: "Дружелюбное приложение, которое не даст Вашему динозавру потеряться!", preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "Спасибо!", style: .default, handler: nil)
        
        alert.addAction(ok)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["kopytov@me.com"])
            mail.setSubject("Приложение iGarazh")
            mail.setMessageBody("<p>Приветствую команду разработчиков!</p>", isHTML: true)
            
            present(mail, animated: true)
        } else {
            // show failure alert
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
