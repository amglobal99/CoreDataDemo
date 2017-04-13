//
//  ViewController.swift
//  CoreDataDemo
//
//  Created by Jack Patil on 4/13/17.
//  Copyright © 2017 Natsys International. All rights reserved.
//


import UIKit
import CoreData


class ViewController: UIViewController, UITableViewDataSource {
  
  
  
  @IBOutlet weak var tableView: UITableView!
  
  
  //var names = [String]()
  var people = [NSManagedObject]()
  
  
  // *******************************************************
  //
  //   add the Record
  //
  // *******************************************************
  
  @IBAction func addName(_ sender: UIBarButtonItem) {
    
    let alert = UIAlertController(title: "New Name & City", message: "Add a new name, city", preferredStyle: .alert)
    
    let saveAction = UIAlertAction(title: "Save", style: .default,
                                   handler: {
                                    (action:UIAlertAction) -> Void in
                                    let textField = alert.textFields!.first
                                    let textField2 = alert.textFields![1]
                                    let textField3 = alert.textFields!.last
                                    self.saveName(name: textField!.text!, city: textField2.text!, gender: textField3!.text!)
                                    //self.saveName(city: textField2!.text!)
                                    self.tableView.reloadData()
    })
    
    let cancelAction = UIAlertAction(title: "Cancel", style: .default) {
      (action: UIAlertAction) -> Void in
    }
    
    // Add three input Fields
    alert.addTextField {
      (textField: UITextField) -> Void in
    }
    
    alert.addTextField {
      (textField: UITextField) -> Void in
    }
    alert.addTextField {
      (textField: UITextField) -> Void in
    }
    
    
    
    
    alert.addAction(saveAction)
    alert.addAction(cancelAction)
    
    present(alert, animated: true, completion: nil)
    
  }  // end function
  
  
  
  
  
  // ********************************************
  //
  //   Save the record
  //
  // ********************************************
  
  func saveName(name: String, city:String, gender: String) {
    let appDelegate =  UIApplication.shared.delegate as! AppDelegate
    let managedContext = appDelegate.persistentContainer.viewContext
    let entity =  NSEntityDescription.entity(forEntityName: "Person",    in:managedContext)
    let person = NSManagedObject(entity: entity!,  insertInto: managedContext)
    person.setValue(name, forKey: "name")
    person.setValue(city, forKey: "city")
    person.setValue(gender, forKey: "gender")
    
    do {
      try managedContext.save()
      people.append(person)
      print("Perosn has been saved...")
      
    } catch let error as NSError  {
      print("Could not save \(error), \(error.userInfo)")
    }
  }  // end function
  
  
  
  
  
  
  
  
  
  
  // We register a UITableViewCell here
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "\"The List\""
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
  }
  
  
  
  
  // We fetch the list of people. List is returned as array of NSManagedObject
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    let appDelegate =  UIApplication.shared.delegate as! AppDelegate
    let managedContext = appDelegate.persistentContainer.viewContext
    let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Person")
    do {
      
      print("Inside viewWillAppear - fetch seems to be ok")
      
      
      let results = try managedContext.fetch(fetchRequest)
      people = results as! [NSManagedObject]
    } catch let error as NSError {
      print("Could not fetch \(error), \(error.userInfo)")
    }
  }  // end function
  
  
  
  
  
  
  // MARK: UITableViewDataSource
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    print("Table has \(people.count) rows")
    
    return people.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt  indexPath: IndexPath) -> UITableViewCell {
    
    print("Inside cellForRow")
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
    let person = people[indexPath.row]
    let nameStr = person.value(forKey: "name") ?? "Not Avail"
    let cityStr = person.value(forKey: "city") ?? "N/A"
    let genderStr = person.value(forKey: "gender") ?? "N/A"
    
    print( "Name: \(nameStr) , City: \(cityStr)" )
    
    cell!.textLabel!.text = "\(nameStr) ,  \(cityStr) , \(genderStr) "
    return cell!
  }
  
  
  
  
}  // end class

