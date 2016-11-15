//
//  TableViewController.swift
//  iGarazh
//
//  Created by Sergey Kopytov on 15.11.16.
//  Copyright © 2016 Sergey Kopytov. All rights reserved.
//

import UIKit
import CoreData

class TableViewController: UITableViewController {
    
    var mas = [Place]()
    
    //let mase = ["oh", "my", "god"]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getData()
        tableView.reloadData()
    }
    
    func getData() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do {
            mas = try context.fetch(Place.fetchRequest())
        }
        catch {
            print ("Fetching error")
        }
    }

    // MARK: - Table view data source

    /*override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }*/

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return mas.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        // Configure the cell...
        
        cell.textLabel?.text = mas[indexPath.row].item! as String
        //cell.textLabel?.text = mase[indexPath.row] as String

        return cell
    }
 
    @IBAction func AddNew(_ sender: Any) {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let place = Place(context: context)
        
        var nameTextField: UITextField?
        
        let alertController = UIAlertController(title: "Добавление предмета", message: nil, preferredStyle: .alert)
        
        let add = UIAlertAction(title: "Добавить", style: .default, handler: { (action) -> Void in
        
            let fields = alertController.textFields!
            
            place.item = fields[0].text!
            
            self.mas.append(place)
            
            self.tableView.reloadData()
            
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        })
        
        let cancel = UIAlertAction(title: "Отменить", style: .default, handler: { (action) -> Void in})
        
        alertController.addAction(cancel)
        alertController.addAction(add)
        alertController.addTextField(configurationHandler: { (textField) -> Void in
        
            nameTextField = textField
            nameTextField?.placeholder = "Введите наименование"
            
        })
        
        present(alertController, animated: true, completion: nil)
        
    }

    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        if editingStyle == .delete {
            // Delete the row from the data source
            let place = mas[indexPath.row]
            context.delete(place)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
            do {
                mas = try context.fetch(Place.fetchRequest())
            }
            catch {
                print ("Fetching error")
            }
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
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
