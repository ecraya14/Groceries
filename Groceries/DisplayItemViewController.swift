//
//  DisplayItemViewController.swift
//  Groceries
//
//  Created by ecraya14 on 03/10/2016.
//  Copyright © 2016 AppFish. All rights reserved.
//

import Foundation
import UIKit

class DisplayItemViewController: UIViewController {

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var searchForDifferentProductButton: UIButton!
    
    
    
    var itemName: String!
    var itemPrice: Double!
    var imgData: Data!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.setValue(descriptionLabel.text, forKey: "description")
        UserDefaults.standard.setValue(itemPrice, forKey: "price")
        let notCenter = NotificationCenter.default
        notCenter.addObserver(self, selector: #selector(appInBackground), name: NSNotification.Name.UIApplicationDidBecomeActive , object: nil)
        view.backgroundColor = UIColor(red: 0.851 , green: 0.837, blue: 0.92, alpha: 1.0)
        indicator.startAnimating()
        
    }
    
    func appInBackground() {
        descriptionLabel.text = UserDefaults.standard.value(forKey: "description") as? String
        priceLabel.text = UserDefaults.standard.value(forKey: "price") as? String
        if let im = UIImage(data: UserDefaults.standard.value(forKey: "imageData") as! Data) {
            itemImage.image = im
        } else {
            itemImage.image = UIImage(named: "groceries")
        }
        
    }
    
    
    
    @IBAction func searchForMoreProducts() {
        // Inject the item in the the as query item for search.
        
        
        //open link in default browser
        Client.sharedInstance().getMoreResults(itemName, completionHandlerForMoreResults: { (itemLink) in
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
}
