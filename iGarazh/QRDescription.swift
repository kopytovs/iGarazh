//
//  QRDescription.swift
//  iGarazh
//
//  Created by Sergey Kopytov on 07.12.16.
//  Copyright © 2016 Sergey Kopytov. All rights reserved.
//

import UIKit

class QRDescription: UIViewController {
    
    var fields = ["lol", "lol", "lol"]
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var scaf: UILabel!
    @IBOutlet weak var descript: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "backgr2"))
        
        name.text = fields[0]
        scaf.text = fields[1]
        descript.text = fields[2]
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
