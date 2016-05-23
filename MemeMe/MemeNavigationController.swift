//
//  MemeNavigationController.swift
//  MemeMe
//
//  Created by Patrick Montalto on 5/23/16.
//  Copyright © 2016 swift. All rights reserved.
//

import UIKit
import CoreData

class MemeNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: #selector(MemeNavigationController.addMeme))
    }
    
    func addMeme() {
        let controller = storyboard!.instantiateViewControllerWithIdentifier("MemeEditorViewController") as! MemeEditorViewController
        
        controller.delegate = self
        
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    // MARK: - Core Data Convenience
    lazy var sharedContext: NSManagedObjectContext = {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }()
}


// MARK: - Meme Editor View Controller Delegate
extension MemeNavigationController: MemeEditorViewControllerDelegate {
    func memeEditor(memeEditor: MemeEditorViewController, didSaveMeme meme: Meme?) {
        if let newMeme = meme {
            // Get tab bar controller
            let tabBarController = self.tabBarController as! MemeTabBarController
            // save the meme to the shared memes array
            tabBarController.memes.append(newMeme)
            
            // debug:
            print(tabBarController.memes.count)
            
            // Save context
            CoreDataStackManager.sharedInstance().saveContext()
        }
        
    }
}