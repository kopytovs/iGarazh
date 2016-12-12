//
//  TableViewController.swift
//  iGarazh
//
//  Created by Sergey Kopytov on 15.11.16.
//  Copyright © 2016 Sergey Kopytov. All rights reserved.
//

import UIKit
import CoreData

class TableViewController: UITableViewController, UISearchBarDelegate {
    
    var mas = [Place]()
    
    var tabs = [Scafs]()

    @IBOutlet weak var SBar: UISearchBar!
    
    var filtered = [Place]()
    
    var SActive: Bool = false
    
    var temp: String = ""
    
    var load: Bool = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        //self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        self.view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "backgr"))
        
        SBar.delegate = self
        
        temp = SBar.text!
        
        SBar.showsCancelButton = false
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if (load){
            getData()
            tableView.reloadData()
            load = false
        }
        print ("kolvo:  \(tabs.count)")

    }
    
    func getData() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do {
            mas = try context.fetch(Place.fetchRequest())
            tabs = try context.fetch(Scafs.fetchRequest())
        }
        catch {
            print ("Fetching error")
        }
    }
    
    func dismissKeyboard(){
        view.endEditing(true)
    }

    // MARK: - Table view data source

    //override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
   //     return tabs.count
   // }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if (SActive){
            return filtered.count
        }
        else {
            return mas.count
        }
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        // Configure the cell...

        cell.textLabel?.text = (SActive && !filtered.isEmpty) ? filtered[indexPath.row].item! as String : mas[indexPath.row].item! as String
        
        cell.detailTextLabel?.text = (SActive && !filtered.isEmpty) ? filtered[indexPath.row].info! as String : mas[indexPath.row].info! as String
        
        return cell
    }
 
    @IBAction func AddNew(_ sender: Any) {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let place = Place(context: context)
        
        let tab = Scafs(context: context)
        
        var nameTextField: UITextField?
        
        var secTextField: UITextField?
        
        var infoTextField: UITextField?
        
        let alertController = UIAlertController(title: "Добавление предмета", message: nil, preferredStyle: .alert)
        
        let add = UIAlertAction(title: "Добавить", style: .default, handler: { (action) -> Void in
        
            let fields = alertController.textFields!
            
            if ((fields[0].text?.isEmpty)! || (fields[1].text?.isEmpty)!){
                
                /*let errorC = UIAlertController(title: "Ошибка!", message: "Введите все данные!", preferredStyle: .alert)
                
                let okay = UIAlertAction(title: "ОК", style: .default, handler: {(alert) -> Void in})
                
                errorC.addAction(okay)
                
                present(errorC, animated: true, completion: nil)*/
                
                print ("Пустые поля!")
                
            } else{
                
                place.item = fields[0].text!
                
                place.number = fields[1].text!
                
                place.info = fields[2].text!
                
                if self.tabs.isEmpty {
                    tab.name = fields[1].text!
                    
                    let tempID = NSUUID().uuidString
                    
                    tab.id = "\(tempID)"
                    
                    place.qr = "\(tempID)"
                    
                    tab.items = 1
                    
                    self.tabs.append(tab)
                    
                } else{
                    
                    var have = false
                    
                    if self.tabs.count == 1{
                        if (self.tabs[0].name == fields[1].text!){
                            have = true
                            place.qr = self.tabs[0].id
                            self.tabs[0].items += 1
                        }
                    } else{
                            for i in 0...self.tabs.count-1{
                                if (self.tabs[i].name == fields[1].text!){
                                    have = true
                                    self.tabs[i].items += 1
                                    place.qr = self.tabs[i].id
                                    break
                                }
                            }
                        }
                    
                    if !(have) {
                        tab.name = fields[1].text!
                        
                        let tempID = NSUUID().uuidString
                        
                        tab.items = 1
                        
                        tab.id = "\(tempID)"
                        
                        place.qr = "\(tempID)"
                        
                        self.tabs.append(tab)
                    }
                    
                }
                
                //place.qr = "\(self.mas.count+1)"
                
                self.mas.append(place)
                
                self.tableView.reloadData()
                
                (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
            }
        
        })
        
        let cancel = UIAlertAction(title: "Отменить", style: .cancel, handler: { (action) -> Void in})
        
        alertController.addAction(cancel)
        alertController.addAction(add)
        alertController.addTextField(configurationHandler: { (textField) -> Void in
        
            nameTextField = textField
            nameTextField?.placeholder = "Наименование"
            //nameTextField?.keyboardType
            
        })
        alertController.addTextField(configurationHandler: { (textField) -> Void in
            
            secTextField = textField
            secTextField?.placeholder = "Шкаф"
            
            
        })
        
        alertController.addTextField(configurationHandler: { (textField) -> Void in
            
            infoTextField = textField
            infoTextField?.placeholder = "Описание (Например номер полки)"
            
        })
        
        if !(nameTextField?.text?.isEmpty)! && !(secTextField?.text?.isEmpty)!{
            
            add.isEnabled = true
            
        } else{
            
            //add.isEnabled = false
            
        }
        
        present(alertController, animated: true, completion: nil)
        
    }

    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.navigationItem.leftBarButtonItem?.isEnabled = false
        self.navigationItem.rightBarButtonItem?.isEnabled = false
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
        self.navigationItem.leftBarButtonItem?.isEnabled = true
        self.navigationItem.rightBarButtonItem?.isEnabled = true
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
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if SActive {
            return false
        } else {
            return true
        }
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let editButt = UITableViewRowAction(style: .normal, title: "Edit") { action, index in
            print("edit button tapped")
            
            var nameTextField: UITextField?
            
            var secTextField: UITextField?
            
            var infoTextField: UITextField?
            
            let alert = UIAlertController(title: "Изменение ячейки", message: nil, preferredStyle: .alert)
            
            let ok = UIAlertAction(title: "OK", style: .default, handler: {(action) -> Void in
            
                let fields = alert.textFields!
                
                if !(fields[0].text?.isEmpty)! {
                    
                    self.mas[indexPath.row].item = fields[0].text
                    
                }
                
                if !(fields[1].text?.isEmpty)!{
                    
                    for i in 0...self.tabs.count-1 {
                        if self.tabs[i].name == self.mas[indexPath.row].number {
                            if self.tabs[i].items == 1 {
                                
                                let tab = self.tabs[i]
                                
                                context.delete(tab)
                                
                                self.tabs.remove(at: i)
                                
                            } else {
                                //print ("end:  \(self.tabs[i].items)")
                                self.tabs[i].items -= 1
                            }
                            break
                        }
                    }
                    
                    self.mas[indexPath.row].number = fields[1].text
                    
                    var have = true
                    
                    for i in 0...self.tabs.count-1 {
                        if self.tabs[i].name == fields[1].text {
                            have = false
                            self.mas[indexPath.row].qr = self.tabs[i].id
                            self.tabs[i].items += 1
                            break
                        }
                    }
                    
                    if have {
                        
                        let tab = Scafs(context: context)
                        
                        tab.items = 1
                        
                        tab.name = fields[1].text
                        
                        let uid = NSUUID().uuidString
                        
                        tab.id = ("\(uid)")
                        
                        self.mas[indexPath.row].qr = tab.id
                        
                        self.tabs.append(tab)
                        
                    }
                }
                
                if !(fields[2].text?.isEmpty)! {
                    
                    self.mas[indexPath.row].info = fields[2].text
                    
                }
                
                self.tableView.reloadData()
                
                (UIApplication.shared.delegate as! AppDelegate).saveContext()
                
                do {
                    
                    self.mas = try context.fetch(Place.fetchRequest())
                    self.tabs = try context.fetch(Scafs.fetchRequest())
                    
                } catch {
                    print ("Fetching error")
                }
                
            })
            
            let cancel = UIAlertAction(title: "Отменить", style: .cancel, handler: nil)
            
            alert.addAction(ok)
            alert.addAction(cancel)
            
            alert.addTextField(configurationHandler: {(textField) -> Void in
                
                nameTextField = textField
                
                nameTextField?.placeholder = "Наименование"
                
            })
            
            alert.addTextField(configurationHandler: {(textField) -> Void in
                
                secTextField = textField
                
                secTextField?.placeholder = "Шкаф"
                
            })
            
            alert.addTextField(configurationHandler: {(textField) -> Void in
                
                infoTextField = textField
                
                infoTextField?.placeholder = " Описание"
                
            })
            
            self.present(alert, animated: true, completion: nil)
        }
        
        editButt.backgroundColor = UIColor.orange
        
        let deleteButt = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
            print("delete button tapped")
            
            //let alert = UIAlertController(title: "Изменение ячейки", message: nil, preferredStyle: .alert)
            // Delete the row from the data source
            let place = self.mas[indexPath.row]
            var tab = Scafs(context: context)
            var index = 0
            
            if self.tabs.count == 1 {
                tab = self.tabs[0]
            } else {
                for i in 0...self.tabs.count-1 {
                    if self.tabs[i].id == place.qr{
                        tab = self.tabs[i]
                        index = i
                        break
                    }
                }
            }
            //здесь ошибка 😔
            if tab.items == 1 {
                context.delete(tab)
                self.tabs.remove(at: index)
            } else{
                self.tabs[index].items -= 1
            }
            
            
            context.delete(place)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
            do {
                self.mas = try context.fetch(Place.fetchRequest())
                self.tabs = try context.fetch(Scafs.fetchRequest())
            }
            catch {
                print ("Fetching error")
            }
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        deleteButt.backgroundColor = UIColor.red
        
        return [deleteButt, editButt]
        
    }

    
    // Override to support editing the table view.
    /*override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        
        if editingStyle == .delete {
            // Delete the row from the data source
            let place = mas[indexPath.row]
            var tab = Scafs(context: context)
            var index = 0
            
            if tabs.count == 1 {
                tab = tabs[0]
            } else {
                for i in 0...tabs.count-1 {
                    if self.tabs[i].id == place.qr{
                        tab = tabs[i]
                        index = i
                        break
                    }
                }
            }
            //здесь ошибка 😔
            if tab.items == 1 {
                context.delete(tab)
                tabs.remove(at: index)
            } else{
                tabs[index].items -= 1
            }
            
            
            context.delete(place)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
            do {
                mas = try context.fetch(Place.fetchRequest())
                tabs = try context.fetch(Scafs.fetchRequest())
            }
            catch {
                print ("Fetching error")
            }
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }*/
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        cell.backgroundColor = .clear
        
        cell.alpha = 0
        
        UIView.animate(withDuration: 1.0, animations: {cell.alpha = 1})
        
    }
    
   // override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
   // }
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        //if segue.identifier == "showDetail"{
        
        if let indexPath = tableView.indexPathForSelectedRow {
            let destinationController = segue.destination as! QRGenViewController
            //destinationController.name = ((SActive) && !(filtered.isEmpty)) ? filtered[indexPath]. : mas
            //print ("гребаный нейм |\(mas[indexPath.row].qr)|")
            //print ("suka:   |\(((SActive) && !(filtered.isEmpty)) ? filtered[indexPath.row].qr! : mas[indexPath.row].qr!)|")
            //print ("chert:   |\(mas[indexPath.row].qr!)|")
            destinationController.name = ((SActive) && !(filtered.isEmpty)) ? filtered[indexPath.row].qr! : mas[indexPath.row].qr!
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
    }
    

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
