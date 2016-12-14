//
//  ScafsTableViewController.swift
//  iGarazh
//
//  Created by Sergey Kopytov on 12.12.16.
//  Copyright © 2016 Sergey Kopytov. All rights reserved.
//

import UIKit

class ScafsTableViewController: UITableViewController, UISearchBarDelegate {
    
    var Tabs = [Scafs]()
    
    var scafs = [Scafs]()
    
    var load = true
    
    var filtered = [Scafs]()
    
    var SActive: Bool = false
    
    var temp : String = ""

    @IBOutlet weak var Sbar: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        temp = Sbar.text!
        
        Sbar.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "backgr"))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        
        Sbar.showsCancelButton = false
        
        if (load){
            getData()
            tableView.reloadData()
            load = false
        }
        
        if Tabs.count == 1{

            if Tabs[0].name != nil {
                scafs.append(Tabs[0])
            }
            
        } else if Tabs.count > 1{
            
            for i in 0...Tabs.count - 1 {
                if Tabs[i].name != nil {
                    scafs.append(Tabs[i])
                }
            }
        }
        print ("itogo:  \(scafs.count)")
    }
    
    func getData() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do {
            Tabs = try context.fetch(Scafs.fetchRequest())
        }
        catch {
            print ("Fetching error")
        }
    }
    
    // MARK: - Table view data source

    //override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
     //   return 0
    //}

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return (SActive) ? filtered.count : scafs.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.cellForRow(at: indexPath)?.isSelected = false
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        // Configure the cell...
        
        cell.textLabel?.text = (SActive && !filtered.isEmpty) ? filtered[indexPath.row].name! as String : scafs[indexPath.row].name! as String
        
        let items : String = (SActive && !filtered.isEmpty) ? String(filtered[indexPath.row].items) : String(scafs[indexPath.row].items)
        
        cell.detailTextLabel?.text = "Всего:  " + "\(items)"

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
        
        filtered = scafs.filter({ (text) -> Bool in
            let tmp: String = text.name! as String
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
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let shareButt = UITableViewRowAction(style: .normal, title: "Share") {action, index in
        
            let qrCode : String = (self.SActive && !self.filtered.isEmpty) ? self.filtered[indexPath.row].id! as String : self.scafs[indexPath.row].id! as String
            
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let indexPath = tableView.indexPathForSelectedRow {
            let destinationController = segue.destination as! MyPlaceTableViewController
            destinationController.scaf = (SActive && !filtered.isEmpty) ? filtered[indexPath.row].id! as String : scafs[indexPath.row].id! as String
        }
    }
 

}
