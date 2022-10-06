//
//  ViewController.swift
//  DataStorageTest
//
//  Created by Carolina Solís on 10/4/22.
//

import UIKit

class ViewController: UIViewController {
    //Initialize Labels
    @IBOutlet weak var firstnameLbl: UILabel!
    @IBOutlet weak var lastnameLbl: UILabel!
    @IBOutlet weak var ageLbl: UILabel!
    
    //Initialize Input Text Boxes
    @IBOutlet weak var firstnameInput: UITextField!
    @IBOutlet weak var lastnameInput: UITextField!
    @IBOutlet weak var ageInput: UITextField!
    
    //Initialize Table View
    @IBOutlet weak var tableView: UITableView!
    
    
    var firstnamesarray = [String]()
    var lastnamesarray = [String]()
    var agesarray = [String]()
    var accumulatedfirstnamearray = [String]()
    
    var defaults = UserDefaults.standard

    
    @IBAction func submitButton(_ sender: Any)
    {
        
        //Saving user input to arrays
        firstnamesarray.append(firstnameInput.text!)
        print("click button",firstnamesarray)
        print("ACCUM",accumulatedfirstnamearray)
        defaults.set(firstnamesarray, forKey: "SavedNameArray")
       
        var savedNameArray = defaults.object(forKey: "SavedNameArray") as? [String] ?? [String]()
        savedNameArray = accumulatedfirstnamearray + savedNameArray
        print("after adding to NSUsers", savedNameArray)
        
        lastnamesarray.append(lastnameInput.text!)
        defaults.set(lastnamesarray, forKey: "SavedLastNameArray")
        
        agesarray.append(ageInput.text!)
        defaults.set(agesarray, forKey: "SavedAgeArray")
      
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Save arrays to NSUsers for data storage
        let savedNameArray = defaults.object(forKey: "SavedNameArray") as? [String] ?? [String]()
        
        let savedLastNameArray = defaults.object(forKey: "SavedLastNameArray") as? [String] ?? [String]()
        let savedAgeArray = defaults.object(forKey: "SavedAgeArray") as? [String] ?? [String]()
        
        //Print saved data
        print("Saved First Names: \(savedNameArray)")
        print("Saved Last Names: \(savedLastNameArray)")
        print("Saved Ages: \(savedAgeArray)")
        
        
        accumulatedfirstnamearray = accumulatedfirstnamearray + savedNameArray
        
        //Table View
        tableView.delegate = self
        tableView.dataSource = self
    }

}

extension ViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        print("you tapped me!")
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //savednamearray initialization
        let savedNameArray = defaults.object(forKey: "SavedNameArray") as? [String] ?? [String]()
        return accumulatedfirstnamearray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //savednamearray initialization
        let savedNameArray = defaults.object(forKey: "SavedNameArray") as? [String] ?? [String]()
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = accumulatedfirstnamearray[indexPath.row]
        
        return cell
    }
}

