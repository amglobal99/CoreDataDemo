//
//  ViewController.swift
//  CoreDataDemo
//
//  Created by Jack Patil on 4/13/17.
//  Copyright © 2017 Natsys International. All rights reserved.
//


import UIKit
import CoreData
import os.log
import Alamofire
import SwiftyJSON



class ViewController: UIViewController, UITableViewDataSource {
  
  
  
  @IBOutlet weak var tableView: UITableView!
  

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
   let managedContext: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
   
   
    
    // create a NSEntityDescription
   let entity: NSEntityDescription? =  NSEntityDescription.entity(forEntityName: "Person",    in:managedContext)
   
   
  
    
    // create a NSManagedObject
   let person: NSManagedObject  = NSManagedObject(entity: entity!,  insertInto: managedContext)
    
    // set values on NSMangedObject
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
    
    NSLog("JACK: STEP 11")
    
    title = "\"The List\""
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
  }
  
  
  
  
  // We fetch the list of people. List is returned as array of NSManagedObject
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    NSLog("JACK: STEP 2")
    
    
    
    let appDelegate =  UIApplication.shared.delegate as! AppDelegate
    let managedContext = appDelegate.persistentContainer.viewContext
    
    // create a NSFtechRequest
    let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Person")
    
    do {
      let results = try managedContext.fetch(fetchRequest)
      people = results as! [NSManagedObject]
    } catch let error as NSError {
      print("Could not fetch \(error), \(error.userInfo)")
    }
  }  // end function
  
  
  
  
  
  
  // MARK: UITableViewDataSource
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    print("JACK: Table has \(people.count) rows")
    NSLog("JACK NSLog:  This is right after porint")
    return people.count
  }
  
  
    /*
      Function gives us the cell content for a Row in our Table
    */
  func tableView(_ tableView: UITableView, cellForRowAt  indexPath: IndexPath) -> UITableViewCell {
    
    //print("Inside cellForRow")
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
    let person = people[indexPath.row]
    let nameStr = person.value(forKey: "name") ?? "Not Avail"
    let cityStr = person.value(forKey: "city") ?? "N/A"
    let genderStr = person.value(forKey: "gender") ?? "N/A"
    
    //print( "Name: \(nameStr) , City: \(cityStr)" )
    
    cell!.textLabel!.text = "\(nameStr) ,  \(cityStr) , \(genderStr) "
    return cell!
  }
  
  
  
  
}  // end class

