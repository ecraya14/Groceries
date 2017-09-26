//
//  Client.swift
//  Groceries
//
//  Created by ecraya14 on 03/10/2016.
//  Copyright © 2016 AppFish. All rights reserved.
//

import Foundation

class Client{
    
    
    var session = URLSession.shared
    

    fileprivate func containsNoSpecialCharacters(_ query: String) -> Bool {
        for ch in query.characters {
            if (!(ch >= "a" && ch <= "z")) && (!(ch >= "A" && ch <= "Z")) && (ch != " ") {
                return false
            }
        }
        return true
    }
    
    func getItemPrice(_ itemName: String, completionHandlerForItemPrice: @escaping (_ success: Bool, _ itemLink: [String: AnyObject]?, _ errorString: String?) -> Void) {
        
        //Parameters
        let query = removeWhitespace(itemName)
        
        let offset = 1
        let limit =  10
        let path: NSString = "https://dev.tescolabs.com/grocery/products/?query=\(query)&offset=\(offset)&limit=\(limit)" as NSString
        print(path)
        if !containsNoSpecialCharacters(query) {
            completionHandlerForItemPrice(false, nil, "Error: path is unvalid.")
        }
        
        let request = NSMutableURLRequest(url: URL(string: path as String)!)
        request.httpMethod = "GET"
        //request headers
        request.addValue(Client.Constants.subscriptionKey, forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
        let task = session.dataTask(with: request as
        URLRequest) {data, response, error in
        
            if error != nil {
                completionHandlerForItemPrice(false, nil, "Error: \(error)")
            }
            else {
                /* GUARD: Was there any data returned? */
                guard let data = data else {
                    completionHandlerForItemPrice(false, nil, "No data was returned by the request!")
                    return
                }
                
                // parse the data
                let parsedResult: AnyObject!
                do {
                    parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
                } catch {
                    completionHandlerForItemPrice(false, nil, "Could not parse the data as JSON")
                    return
                }
                
                
                /* GUARD: Is the "uk" key in our result? */
                guard let ukProductsDictionary = parsedResult["uk"] as? [String:AnyObject] else {
                    completionHandlerForItemPrice(false, nil, "Cannot find key 'uk' in parsedResult")
                    return
                }
                
                /* GUARD: Is the "ghs" key in our result? */
                guard let ukghsProductsDictionary = ukProductsDictionary["ghs"] as? [String:AnyObject] else {
                    completionHandlerForItemPrice(false, nil, "Cannot find key 'ghs' in dictionary")
                    return
                }
                /* GUARD: Is the "products" key in our result? */
                guard let productsDictionary = ukghsProductsDictionary["products"] as? [String:AnyObject] else {
                    completionHandlerForItemPrice(false, nil, "Cannot find key 'products' in dictionary")
                    return
                }
                
                /* GUARD: Is the "results" key in productsDictionary? */
                guard let resultsArray = productsDictionary["results"] as? [[String: AnyObject]] else {
                    completionHandlerForItemPrice(false, nil, "Cannot find key 'results' in dictionary")
                    return
                }
                
                if resultsArray.count == 0 {
                    completionHandlerForItemPrice(false, nil, "No results Found. Check the spelling.")
                    return
                } else {
                    // pick a random item!
                    let chosenResult = min(resultsArray.count, limit)
                    let randomItem = Int(arc4random_uniform(UInt32(chosenResult)))
                    let chosenItem = resultsArray[randomItem]
                    
                    completionHandlerForItemPrice(true, chosenItem, nil)
                }

            }
        }
        task.resume()
    }
    
    fileprivate func removeWhitespace(_ itemName: String) -> String {
        let whitespace = CharacterSet.whitespaces
        let range = itemName.rangeOfCharacter(from: whitespace)
        if range != nil {
            return itemName.replacingOccurrences(of: " ", with: "+")
        } else {
            return itemName
        }
    }
    
    func getMoreResults(_ itemName: String, completionHandlerForMoreResults: (_ path: String) -> Void) {
        //Parameters
        let query = removeWhitespace(itemName)
        let newSort = "true"
        let search = "Search"
        let path: NSString = "http://www.tesco.com/groceries/product/search/default.aspx?searchBox=\(query)&newSort=\(newSort)&search=\(search)" as NSString
        
        completionHandlerForMoreResults(path as String)
    }
    
    
    class func sharedInstance() -> Client {
        struct Singleton {
            static var sharedInstance = Client()
        }
        return Singleton.sharedInstance
    }
}


extension Client {
    struct Constants {
        static let subscriptionKey: String = "41060dd8e2fe4cc188bb5aee45a81a34"
    }
}
