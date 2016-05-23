//
//  MemeTabBarController.swift
//  MemeMe
//
//  Created by Patrick Montalto on 5/23/16.
//  Copyright © 2016 swift. All rights reserved.
//

import UIKit
import CoreData

class MemeTabBarController: UITabBarController {
    
    // Shared Memes model: an array of Meme objects
    var memes = [Meme]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        memes = fetchAllMemes()
    }
    
    // MARK: - Core Data Convenience
    
    func fetchAllMemes() -> [Meme] {
        // create fetch request
        let fetchRequest = NSFetchRequest(entityName: "Meme")
        
        // attempt to fetch memes data
        do {
            return try sharedContext.executeFetchRequest(fetchRequest) as! [Meme]
        } catch let error as NSError {
            print("Error in fetchAllMemes: \(error.localizedDescription)")
            return [Meme]()
        }
    }
    
    lazy var sharedContext: NSManagedObjectContext = {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }()
}
