//
//  MyPlaceTableViewController.swift
//  iGarazh
//
//  Created by Sergey Kopytov on 18.11.16.
//  Copyright © 2016 Sergey Kopytov. All rights reserved.
//

import UIKit

class MyPlaceTableViewController: UITableViewController, UISearchBarDelegate {
    
    var defmas = [Place]()
    
    var mas = [Place]()
    
    var tabs = [Scafs]()
    
    var nameS: String = ""
    
    var scaf: String = ""
    
    var filtered = [Place]()
    
    var SActive: Bool = false
    
    var temp: String = ""
    
    var load: Bool = true
    
    @IBOutlet weak var SBar: UISearchBar!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "backgr"))
        
        SBar.delegate = self
        
        temp = SBar.text!
        
        //print("Шкаф под номером |\(scaf)|")
        
        SBar.placeholder = "Поиск по шкафу"
        
        SBar.showsCancelButton = false
        
        self.navigationItem.title = "Шкаф"
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do {
            defmas = try context.fetch(Place.fetchRequest())
            tabs = try context.fetch(Scafs.fetchRequest())
        }
        catch {
            print ("Fetching error")
        }
        
        var have = false
        if self.tabs.isEmpty{
            let alertC = UIAlertController(title: "Ошибка", message: "Не найден шкаф!!!", preferredStyle: .alert)
            
            let OK = UIAlertAction(title: "OK", style: .default, handler: {(alert) -> Void in})
            
            alertC.addAction(OK)
            
            present(alertC, animated: true, completion: {(alert) -> Void in})
            
        } else{
            if tabs.count == 1 {
                if tabs[0].id == scaf {
                    have = true
                }
            } else {
        for i in 0...tabs.count-1 {
            if tabs[i].id == scaf {
                have = true
                //scaf = tabs[i].name!
                break
            }
            }
            }
        }
        
        if have {
            
            if defmas.count == 1 {
                
                if defmas[0].qr == scaf {
                    mas.append(defmas[0])
                }
                
            } else{
            
            for i in 0...defmas.count-1{
                if defmas[i].qr == scaf {
                    mas.append(defmas[i])
                }
            }
            }
            
            self.navigationItem.title = defmas[0].number
            
        } else{
            
            let alertC = UIAlertController(title: "Ошибка!", message: "Не найден шкаф!!!", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: {(alert) -> Void in})
            
            alertC.addAction(ok)
            
            present(alertC, animated: true, completion: nil)
            
        }
        
    }

    // MARK: - Table view data source

    /*override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }*/

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //if mas.isEmpty {
         //   return 0
        //} else{
            //print (mas.count)
        return (SActive) ? filtered.count : mas.count
        //}
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        // Configure the cell...
        
        if mas.isEmpty {
            
        } else{
        
            cell.textLabel?.text = (SActive && !filtered.isEmpty) ? filtered[indexPath.row].item! as String : mas[indexPath.row].item! as String
        
            cell.detailTextLabel?.text = (SActive && !filtered.isEmpty) ? filtered[indexPath.row].info! as String : mas[indexPath.row].info! as String
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        cell.backgroundColor = .clear
        
        cell.alpha = 0
        
        UIView.animate(withDuration: 0.5, animations: {cell.alpha = 1})
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        //self.navigationItem.leftBarButtonItem?.isEnabled = false
        //self.navigationItem.rightBarButtonItem?.isEnabled = false
        searchBar.showsCancelButton = true
        SActive = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        //self.navigationItem.leftBarButtonItem?.isEnabled = true
        SActive = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = temp
        searchBar.showsCancelButton = false
        //self.navigationItem.leftBarButtonItem?.isEnabled = true
        //self.navigationItem.rightBarButtonItem?.isEnabled = true
        self.view.endEditing(true)
        SActive = false
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
        //self.navigationItem.leftBarButtonItem?.isEnabled = true
        searchBar.showsCancelButton = true
        SActive = true
    }
    
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filtered = mas.filter({ (text) -> Bool in
            let tmp: String = text.item! as String
            let range = tmp.range(of: searchText, options: String.CompareOptions.caseInsensitive)
            //let range = tmp.rangeO(searchText, options: String.CompareOptions.CaseInsensitive)
            return range != nil
        })
        
        if(filtered.isEmpty){
            SActive = false;
        } else {
            SActive = true;
        }
        
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let name: String = (SActive && !filtered.isEmpty) ? filtered[indexPath.row].item! as String : mas[indexPath.row].item! as String
        
        //let number: String = (SActive && !filtered.isEmpty) ? filtered[indexPath.row].number! as String : mas[indexPath.row].number! as String
        
        let descr = (SActive && !filtered.isEmpty) ? filtered[indexPath.row].info! as String : mas[indexPath.row].info! as String
        
        let main : String = "\n" + "Наименование:  " + name +  "\n\n" + "Описание:  " + descr
        
        let info = UIAlertController(title: " Информация о товаре", message: main, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "Спасибо!", style: .default, handler: nil)
        
        info.addAction(ok)
        
        present(info, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let shareButt = UITableViewRowAction(style: .normal, title: "Share") {action, index in
            
            let qrCode : String = (self.SActive && !self.filtered.isEmpty) ? self.filtered[indexPath.row].qr! as String : self.mas[indexPath.row].qr! as String
            
            //print ("lol: \(qrCode)")
            
            var image: UIImage = self.generateQRCode(from: qrCode)!
            
            image = image.resizeWith(width: 1000)!
            
            let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            
            self.present(activityViewController, animated: true, completion: nil)
            
        }
        
        shareButt.backgroundColor = UIColor.blue
        
        return [shareButt]
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
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if let indexPath = tableView.indexPathForSelectedRow {
            let destinationController = segue.destination as! QRDescription
            //destinationController.name = ((SActive) && !(filtered.isEmpty)) ? filtered[indexPath]. : mas
            //print ("гребаный нейм |\(mas[indexPath.row].qr)|")
            //print ("suka:   |\(((SActive) && !(filtered.isEmpty)) ? filtered[indexPath.row].qr! : mas[indexPath.row].qr!)|")
            //print ("chert:   |\(mas[indexPath.row].qr!)|")
            //print ("chert:   |\(mas[indexPath.row].item)|")
            destinationController.fields[0] = ((SActive) && !(filtered.isEmpty)) ? "Имя:   " + filtered[indexPath.row].item! : "Имя:   " + mas[indexPath.row].item!
            destinationController.fields[1] = ((SActive) && !(filtered.isEmpty)) ? "Шкаф:   " + filtered[indexPath.row].number! : "Шкаф:   " + mas[indexPath.row].number!
            destinationController.fields[2] = ((SActive) && !(filtered.isEmpty)) ? "Описание:   " + filtered[indexPath.row].info! : "Описание:   " + mas[indexPath.row].info!
            //print ("ololo:   |\(destinationController.item.text)|")
            //print ("ololo:   |\(destinationController.scaf.text)|")
            //print ("ololo:   |\(destinationController.descript.text)|")
            //print ("The end is near!")
            //destinationController.name = mas
            //}
            
        }
        
        
    }*/
 

}
