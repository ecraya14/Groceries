//
//  ItemViewController.swift
//  Groceries
//
//  Created by ecraya14 on 28/09/2016.
//  Copyright © 2016 AppFish. All rights reserved.
//

import UIKit

class ItemViewController: CoreDataTableViewController {
    
    var stack: CoreDataStack {
        return (UIApplication.shared.delegate as! AppDelegate).stack
    }
    
    var list: List?
    
    var itemName: String = "New Item"
     var searchItemName: String = "New item"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    // MARK:  - TableView Data Source
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Get the note
        let item = fetchedResultsController?.object(at: indexPath) as! Item
        
        // Get the cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemTableViewCell
        
        // Sync note -> cell
        DispatchQueue.main.async(execute: {
            cell.textName.text = item.itemName
            if item.boughtItem != nil {
                cell.picture.image = UIImage(named: "bought")
            } else {
                //image is set to default shopping cart
            }
        })
        
        
        // Return the cell
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Get cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemTableViewCell
        
        if let context = fetchedResultsController?.managedObjectContext, let item = fetchedResultsController?.object(at: indexPath) as? Item, let l = list {
            
            cell.picture.image = UIImage(named: "bought")
            cell.textName.text = item.itemName
            
            //save changes
            context.delete(item)
            let newItem = Item(itemName: cell.textName.text!, boughtItem: "bought", context: context)
            newItem.list = l
            stack.save()
            
            
        }
        
    }
    
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCellEditingStyle,
                                               forRowAt indexPath: IndexPath) {
        
        
        if let context = fetchedResultsController?.managedObjectContext,
            let item = fetchedResultsController?.object(at: indexPath) as? Item, editingStyle == .delete{
            
            context.delete(item)
            
        }
    }
    
    
    
    
    @IBAction func addNewNote(_ sender: AnyObject) {
        
        //create alert controller where user can type in list name
        let alert = UIAlertController(title: "New Item", message: "", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addTextField(configurationHandler: {(tf: UITextField) in
            tf.placeholder = "Enter item name... "
        } )
        
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { [weak self] (paramAction:UIAlertAction!) in
            if let textFields = alert.textFields{
                let textFs = textFields as [UITextField]
                if let enteredText = textFs[0].text {
                    self!.itemName = enteredText
                }
                DispatchQueue.main.async(execute: {
                    if let addToList = self!.list, let context = self!.fetchedResultsController?.managedObjectContext{
                        // Just create a new note and it's done!
                        let item = Item(itemName: self!.itemName, boughtItem: nil, context: context)
                        item.list = addToList
                    }
                })
            }
            
            } ))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    /* 
     * Get the item price and display it in a new view
     */
   
    fileprivate func checkPrice(_ sender: AnyObject, completionHandlerForPrice: @escaping (_ success: Bool, _ array: [String: AnyObject]?, _ itemName: String?) -> Void) {
        let button = sender as! UIButton
        let view = button.superview!
        let cell = view.superview as! ItemTableViewCell
        if let indexPath = tableView.indexPath(for: cell) {
            if let item = fetchedResultsController?.object(at: indexPath) as? Item {
                searchItemName = item.itemName!
                Client.sharedInstance().getItemPrice(item.itemName!, completionHandlerForItemPrice: { (success, chosenItem, errorString) in
                    
                    if success {
                        completionHandlerForPrice(true, chosenItem, item.itemName)
                    } else {
                        completionHandlerForPrice(false, nil, nil)
                    }
     
                })
            }
            
        }
    }
    
    // MARK:  - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "checkPriceView" {
            
            // Get the item price and display it in a new view
            checkPrice(sender! as AnyObject) { (success, chosenItem, itemName) in
                if success {
                    if let priceItem = chosenItem!["price"], let photo = chosenItem!["image"], let des = chosenItem!["name"] {
                        //display in next view
                        if let vc = segue.destination as? DisplayItemViewController {
                            if vc.indicator != nil { //think this messes it up wrong else conncection
                                
                                vc.indicator.hidesWhenStopped = true
                                vc.indicator.startAnimating()
                                let price = priceItem as! Double
                                DispatchQueue.main.async(execute: {
                                    vc.searchForDifferentProductButton.layer.cornerRadius = 20
                                    
                                    vc.priceLabel.text = "Price: £ \(String(format: "%.2f", price))"
                                    vc.descriptionLabel.text = des as? String
                                    UserDefaults.standard.setValue(des, forKey: "description")
                                    UserDefaults.standard.setValue("Price: £ \(String(format: "%.2f", price))", forKey: "price")
                                    
                                })
                                if let url = URL(string: photo as! String) {
                                    if let data = try? Data(contentsOf: url) {
                                        vc.imgData = data
                                        UserDefaults.standard.setValue(data, forKey: "imageData")
                                        DispatchQueue.main.async(execute: {
                                            vc.itemImage.image = UIImage(data: data)
                                            vc.indicator.stopAnimating()
                                            vc.searchForDifferentProductButton.isEnabled = true
                                        })
                                    }
                                }
                                
                                vc.itemPrice = price
                                vc.itemName = itemName//set name so that user has the opportunity to search for other results.
                            } else {
                                //alert view
                                let alertController = UIAlertController(title: "No result", message: "Could not get the price, try again later", preferredStyle: .alert)
                                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action: UIAlertAction!) in
                                    self.navigationController?.popViewController(animated: true)
                                }))
                                
                                self.present(alertController, animated: true, completion: nil)
                            }
                        } else {
                            //alert view
                            let alertController = UIAlertController(title: "No result", message: "Could not get the price, try again later", preferredStyle: .alert)
                            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action: UIAlertAction!) in
                                self.navigationController?.popViewController(animated: true)
                            }))
                            
                            self.present(alertController, animated: true, completion: nil)
                        }

                    } else {
                        //alert view
                        let alertController = UIAlertController(title: "No result", message: "Could not get the price, try again later", preferredStyle: .alert)
                        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action: UIAlertAction!) in
                            self.navigationController?.popViewController(animated: true)
                        }))
                        
                        self.present(alertController, animated: true, completion: nil)
                    }

                } else {
                    //alert view
                    let alertController = UIAlertController(title: "No result", message: "Try spelling the item differently or check your internet connection. Do you want to search on Tesco's webpage?", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: {(action: UIAlertAction!) in
                        self.moreResults(self.searchItemName)
                    }))
                    alertController.addAction(UIAlertAction(title: "No", style: .default, handler: {(action: UIAlertAction!) in
                        self.navigationController?.popViewController(animated: true)
                    }))
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
            
        }
    }
    
    fileprivate func moreResults(_ item: String) {
        //open link in default browser
        Client.sharedInstance().getMoreResults(item, completionHandlerForMoreResults: { (itemLink) in
            let itemResults = URL(string: itemLink)
            let app = UIApplication.shared
            if let itemLink = itemResults {
                app.openURL(itemLink)
            } else {
                let alertController = UIAlertController(title: "Could not find any products", message: "Try spelling the item differently and try again", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in
                    self.dismiss(animated: true, completion: nil)
                }))
                
                self.present(alertController, animated: true, completion: nil)
            }
        })

    }
    
    fileprivate func alert() {
    
    }
    
    
}
