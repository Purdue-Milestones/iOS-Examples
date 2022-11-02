//
//  ViewController.swift
//  CoreDataExample
//
//  Created by Carolina Solís on 10/14/22.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet var table: UITableView!
    
    //reference to managed object context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //data for table
    var items:[Person]?
    
    //viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        table.delegate = self
        table.dataSource = self
        
        //get items from Core Data
        fetchPeople()
        
    }
    
    func relationshipDemo() {
        //create a family
        let family = Family(context: context)
        family.name = "Familia X"
        
        //create a person
        let person = Person(context: context)
        person.name = "Persona X"
        
        //add person to family
        family.addToPeople(person)
        
        //save context
        try! context.save()
    }
    
    func fetchPeople(){
        // fetch data from Core Data to display in tableview
        do {
            let request = Person.fetchRequest() as NSFetchRequest<Person>
            
            //set FILTERING and shorting on request
            //let pred = NSPredicate(format: "name CONTAINS %@","Milo")
            //request.predicate = pred
            
            //set SORTING
            let sort = NSSortDescriptor(key: "name", ascending: true)
            request.sortDescriptors = [sort]
            
            self.items = try context.fetch(request)
            DispatchQueue.main.async {
                self.table.reloadData()
            }
        }
        catch {
            
        }
    }
    
    func showAlert() {
    //Create alert
    let alert = UIAlertController(title: "Add Person", message: "What is their name?", preferredStyle: .alert)
    alert.addTextField()
    
    //configure button handler
    let submitButton = UIAlertAction(title: "Submit", style: .default){ (action) in
        // get the text field for the alert
        let textfield = alert.textFields![0]
        
        //create person objectc
        let newPerson = Person(context: self.context)
        newPerson.name = textfield.text
        newPerson.age = 20
        newPerson.gender = "Male"
        
        //Save the data
        do {
           try self.context.save()
        }
        catch {
            
        }
        
        
        // Re-fetch the data
        self.fetchPeople()
    }
        //Add button
        alert.addAction(submitButton)
        
        //Show alert
        self.present(alert,animated: true, completion: nil)
        
}
    @IBAction func addTapped(_ sender: Any) {
        showAlert()
    }
    

}

   
    
    
    
    extension ViewController: UITableViewDelegate, UITableViewDataSource{
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            //return the number of people
            return self.items?.count ?? 0
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PersonCell", for: indexPath)
            //get person from aarray and set the label
            let person = self.items![indexPath.row]
            
            cell.textLabel?.text = person.name
            
            return cell
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
            //selected person
            let person = self.items![indexPath.row]
            
            //create alert
            let alert = UIAlertController(title: "Edit Person", message: "Edit name:", preferredStyle: .alert)
            alert.addTextField()
            
            let textfield = alert.textFields![0]
            textfield.text = person.name
            
            //configure button handler
            let saveButton = UIAlertAction(title: "Save", style: .default) { (action) in
                //get the textfield for the alert
                let textfield = alert.textFields![0]
                
                //edit name property of person object
                person.name = textfield.text
                
                //save the data
                do {
                    try self.context.save()
                }
                catch {
                    
                }
                //refetch the data
                self.fetchPeople()
                
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
                self.fetchPeople()
            }
            
            // Return swipe actions
            return UISwipeActionsConfiguration(actions: [action])
        }
        
        
    }
    
    



