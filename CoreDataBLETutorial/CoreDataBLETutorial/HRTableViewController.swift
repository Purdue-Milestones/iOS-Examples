//
//  HRTableViewController.swift
//  CoreDataBLETutorial
//
//  Created by Carolina Solís on 11/7/22.
//


import UIKit
import Charts
import Foundation
import CoreBluetooth
import CoreData

class HRTableViewController: UIViewController{
    
    
    @IBOutlet weak var sideMenuBtn: UIBarButtonItem!
    
    @IBOutlet weak var table: UITableView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var items: [HRValue]?
    let defaults = UserDefaults.standard
    
    func fetchHRs(){
            // fetch data from Core Data to display in tableview
            do {
                let request = HRValue.fetchRequest() as NSFetchRequest<HRValue>
                
                self.items = try context.fetch(request)
                DispatchQueue.main.async {
                    self.table.reloadData()
                    print(self.items!)
                }
            }
            catch {
                
            }
        }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Side menu
        sideMenuBtn.image = UIImage(systemName: "text.justify")
        sideMenuBtn.target = revealViewController()
        sideMenuBtn.action = #selector(revealViewController()?.revealSideMenu)
        
        table.delegate = self
        table.dataSource = self
        fetchHRs()
    }
    
}

//TABLE
extension HRTableViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return the number of people
        return self.items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HRCell2", for: indexPath)
        //get person from array and set the label
        let storedHR = self.items![indexPath.row]
        
        let a = storedHR.heartrate!
        let b = storedHR.datesaved ?? "No date"
        
        let first = a + "                   " + b
        
        cell.textLabel?.text = first
       // cell.textLabel?.text = storedHR.date
        
        cell.textLabel?.textAlignment = .center
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //selected person
        let storedHR = self.items![indexPath.row]
        
        //create alert
        let alert = UIAlertController(title: "Edit Person", message: "Edit name:", preferredStyle: .alert)
        alert.addTextField()
        
        let textfield = alert.textFields![0]
        textfield.text = storedHR.heartrate
        
        //configure button handler
        let saveButton = UIAlertAction(title: "Save", style: .default) { (action) in
            //get the textfield for the alert
            let textfield = alert.textFields![0]
            
            //edit name property of person object
            storedHR.heartrate = textfield.text
            
            //save the data
            do {
                try self.context.save()
            }
            catch {
                
            }
            //refetch the data
            self.fetchHRs()
            
        }
        //Add button
        alert.addAction(saveButton)
        
        //Show alert
        self.present(alert,animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            
            //which person to remove
            let personToRemove = self.items![indexPath.row]
            
            //remove the person
            self.context.delete(personToRemove)
            
            //save the data
            do {
                try self.context.save()
            }
            catch {
                
            }
            
            //refetch the data
            self.fetchHRs()
        }
        
        // Return swipe actions
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    
}
