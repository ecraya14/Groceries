//
//  ListsTableViewController.swift
//  Groceries
//
//  Created by ecraya14 on 27/09/2016.
//  Copyright © 2016 AppFish. All rights reserved.
//

import CoreData
import UIKit

class ListsTableViewController: CoreDataTableViewController {
    
    var userListName: String = "New List"
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        tableView.backgroundColor = UIColor(red: 0.301 , green: 0.258, blue: 0.47, alpha: 1.0)
    }
    
    @IBAction func addNewList(_ sender: AnyObject) {
        
        createNewList()
    }
    
    func createNewList() {
        //create alert controller where user can type in list name
        let alert = UIAlertController(title: "New List", message: "", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addTextField(configurationHandler: {(tf: UITextField) in
            tf.placeholder = "Enter a list name... "
        } )
        
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { [weak self] (paramAction:UIAlertAction!) in
            if let textFields = alert.textFields{
                let textFs = textFields as [UITextField]
                if let enteredText = textFs[0].text {
                    self!.userListName = enteredText
                }
                DispatchQueue.main.async(execute: {
                    let _ = List(name: self!.userListName, context: self!.fetchedResultsController!.managedObjectContext)
                })
            }
            
            } ))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func newList() {
        DispatchQueue.main.async(execute: {
            let _ = List(name: self.userListName, context: self.fetchedResultsController!.managedObjectContext)
        })
        tableView.reloadData()
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = UIColor(red: 0.301 , green: 0.258, blue: 0.47, alpha: 1.0)
        // Set the title
        title = "Grocery Lists"
        
        // Get the stack
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let stack = delegate.stack
        
        
        // Create a fetchrequest
        let fr = NSFetchRequest<NSFetchRequestResult>(entityName: "List")
        fr.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true),
                              NSSortDescriptor(key: "creationDate", ascending: false)]
        
        // Create the FetchedResultsController
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fr,
                                                              managedObjectContext: stack.context, sectionNameKeyPath: nil, cacheName: nil)
    }

    
    
    // MARK:  - TableView Data Source
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Find the right list for this indexpath
        let list = fetchedResultsController!.object(at: indexPath) as! List
        
        
        // Create the cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath)
        
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = UIColor(red: 0.851 , green: 0.837, blue: 0.92, alpha: 1.0)
        } else {
            cell.backgroundColor = UIColor(red: 0.839 , green: 0.8235, blue: 0.901, alpha: 1.0)
        }
        
        
        
        // Sync list -> cell
        cell.textLabel?.text = list.name
        cell.detailTextLabel?.text = String(format: "%d items", list.items!.count)
        
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if let context = fetchedResultsController?.managedObjectContext,
            let list = fetchedResultsController?.object(at: indexPath) as? List, editingStyle == .delete{
            
            context.delete(list)
            
        }
        
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showItems" {
            if let vc = segue.destination as? ItemViewController{
                
                // Create Fetch Request
                let fr = NSFetchRequest<NSFetchRequestResult>(entityName: "Item")
                
                fr.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false),
                                      NSSortDescriptor(key: "itemName", ascending: true)]
                
                // we have a search that will match ALL items.
                // only interested in those within the current list:
                // using NSPredicate
                let indexPath = tableView.indexPathForSelectedRow!
                let list = fetchedResultsController?.object(at: indexPath) as? List
                let pred = NSPredicate(format: "list = %@", argumentArray: [list!])
                
                fr.predicate = pred
                
                // Create FetchedResultsController
                let fc = NSFetchedResultsController(fetchRequest: fr,
                                                    managedObjectContext:fetchedResultsController!.managedObjectContext,
                                                    sectionNameKeyPath: "age",
                                                    cacheName: nil)
                
                vc.fetchedResultsController = fc
                vc.list = list
                vc.navigationItem.title = list?.name
                
            }

        }
    }
    
    @IBAction func unwindToOverview(_ segue: UIStoryboardSegue) {}
    
}
