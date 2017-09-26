//
//  StartViewController.swift
//  Groceries
//
//  Created by ecraya14 on 27/09/2016.
//  Copyright © 2016 AppFish. All rights reserved.
//

import Foundation
import UIKit

class StartViewController: UIViewController {
    
    @IBOutlet weak var imageViewLogo: UIImageView!
    @IBOutlet weak var userListsButton: UIButton!
    @IBOutlet weak var newListButton: UIButton!
    

    
    @IBAction func newList() {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ListsView") as! ListsTableViewController
        //create alert controller where user can type in list name
        let alert = UIAlertController(title: "New List", message: "", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addTextField(configurationHandler: {(tf: UITextField) in
            tf.placeholder = "Enter a list name... "
        } )
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { [weak self] (paramAction:UIAlertAction!) in
            if let textFields = alert.textFields{
                let textFs = textFields as [UITextField]
                if let enteredText = textFs[0].text {
                    vc.userListName = enteredText
                    vc.newList()
                    self?.performSegue(withIdentifier: "listOverview", sender: self)
                }
            }
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        
        present(alert, animated: true, completion: nil)
        
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return  UIInterfaceOrientationMask.portrait
    }
}
