//
//  SentMemesTableViewController.swift
//  MemeMe
//
//  Created by Patrick Montalto on 4/8/16.
//  Copyright © 2016 swift. All rights reserved.
//

import UIKit
import CoreData

class SentMemesTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var memes = [Meme]()
    
    @IBOutlet var memesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tabBarController = self.tabBarController as! MemeTabBarController
        // set memes as memes from tab bar controller
        memes = tabBarController.memes
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        let tabBarController = self.tabBarController as! MemeTabBarController
        // set memes as memes from tab bar controller
        memes = tabBarController.memes
        
        // refresh table data
        memesTableView.reloadData()
        memesTableView.separatorColor = UIColor.clearColor()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // return meme cell
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeCell") as! MemeTableViewCell
        let meme = memes[indexPath.row]
        
        // set text and image
        cell.memeText?.text = "\(meme.topText)...\(meme.bottomText)"
        cell.previewImage?.image = meme.image
        setTextAttributes(cell, meme: meme)
            
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // present meme detail view controller 
        let detailController = storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        detailController.meme = memes[indexPath.row]
        navigationController!.pushViewController(detailController, animated: true)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 128.0
    }
    
    func setTextAttributes(cell: MemeTableViewCell, meme: Meme) {
        
        let fontSize = cell.previewTopText.font.pointSize
        let memeTextAttributes = [
            NSStrokeColorAttributeName: UIColor.blackColor(),
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSFontAttributeName: UIFont(name: meme.fontName, size: fontSize)!,
            NSStrokeWidthAttributeName: -5.0
        ]
        
        cell.previewTopText.attributedText = NSAttributedString(string: meme.topText, attributes: memeTextAttributes)
        cell.previewBottomText.attributedText = NSAttributedString(string: meme.bottomText, attributes: memeTextAttributes)
    }
    
    @IBAction func addMeme(sender: AnyObject) {
        let controller = storyboard!.instantiateViewControllerWithIdentifier("MemeEditorViewController") as! MemeEditorViewController
        
        controller.delegate = self
        
        self.presentViewController(controller, animated: true, completion: nil)

    }
    // Enable editing on table view cells
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == .Delete) {
            // get meme
            let meme = memes[indexPath.row]
            
            // remove from shared meme array
            let tabBarController = self.tabBarController as! MemeTabBarController
            tabBarController.memes.removeAtIndex(indexPath.row)
            
            // remove from current memes array
            memes.removeAtIndex(indexPath.row)
            memesTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            
            // remove the meme from the context
            sharedContext.deleteObject(meme)
            CoreDataStackManager.sharedInstance().saveContext()
        }
    }
    
    // MARK: - Core Data Convenience
    lazy var sharedContext: NSManagedObjectContext = {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }()
    
}

// MARK: - MemeEditorViewController Delegate
extension SentMemesTableViewController: MemeEditorViewControllerDelegate {
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
