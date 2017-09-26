//
//  AppDelegate.swift
//  Groceries
//
//  Created by ecraya14 on 27/09/2016.
//  Copyright © 2016 AppFish. All rights reserved.
//
import Foundation
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var stack = CoreDataStack(modelName: "Model")!
    
    func checkState() {
        if UserDefaults.standard.bool(forKey: "inBackground") {
            
        } else {
            //do nothing - lauch as usual
        }
    }
    
    func preData() {
        
        
        let simpleShopping = List(name: "Simple Shopping", context: stack.context)
        let bigShopping = List(name: "Lots of groceries", context: stack.context)
        let workoutShopping = List(name: "Shopping for workout", context: stack.context)
        
        //create items
        let water = Item(itemName: "Volvic", boughtItem: nil, context: stack.context)
        let milk = Item(itemName: "milk", boughtItem: nil, context: stack.context)
        let cheese = Item(itemName: "cheese", boughtItem: nil, context: stack.context)
        let apples = Item(itemName: "apples", boughtItem: nil, context: stack.context)
        let kiwi = Item(itemName: "kiwi", boughtItem: nil, context: stack.context)
        let bananas = Item(itemName: "bananas", boughtItem: nil, context: stack.context)
        let beans = Item(itemName: "beans", boughtItem: nil, context: stack.context)
        let chicken = Item(itemName: "chicken", boughtItem: nil, context: stack.context)
        let carrot = Item(itemName: "carrot", boughtItem: nil, context: stack.context)
        let eggs = Item(itemName: "eggs", boughtItem: nil, context: stack.context)
        let bagels = Item(itemName: "bagels", boughtItem: nil, context: stack.context)
        let scones = Item(itemName: "scones", boughtItem: nil, context: stack.context)
        let proteinB = Item(itemName: "protein", boughtItem: nil, context: stack.context)
        let proteinWhey = Item(itemName: "whey", boughtItem: nil, context: stack.context)
        let rec = Item(itemName: "cookie", boughtItem: nil, context: stack.context)
        let energy = Item(itemName: "energy gel", boughtItem: nil, context: stack.context)
        
        
        water.list = simpleShopping
        milk.list = simpleShopping
        apples.list = bigShopping
        kiwi.list = bigShopping
        cheese.list = bigShopping
        bananas.list = bigShopping
        beans.list = bigShopping
        chicken.list = bigShopping
        carrot.list = bigShopping
        eggs.list = bigShopping
        bagels.list = bigShopping
        scones.list = bigShopping
        proteinB.list = workoutShopping
        proteinWhey.list = workoutShopping
        rec.list = workoutShopping
        energy.list = workoutShopping
        
    }
    
    fileprivate func removeAllPreviousData() {
        //Remove previous stuff (if any)
        do{
            try stack.dropAllData()
        }catch{
            print("Error droping all objects in DB")
        }
    }


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        /* Delete all lists, if you want to */
        //removeAllPreviousData()
        
        //load some pre-written data
        preData()

        stack.autoSave(3)

        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        stack.save()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        UserDefaults.standard.set(true, forKey: "inBackground")
        
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        //checkState()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        UserDefaults.standard.set(false, forKey: "inBackground")
    }


}

