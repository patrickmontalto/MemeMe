//
//  SentMemesTableViewController.swift
//  MemeMe
//
//  Created by Patrick Montalto on 4/8/16.
//  Copyright © 2016 swift. All rights reserved.
//

import UIKit

class SentMemesTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var memes = [Meme]()
    
    @IBOutlet var memesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        memes = appDelegate.memes
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
    
    // Enable editing on table view cells
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == .Delete) {
            // remove from shared meme model
            let object = UIApplication.sharedApplication().delegate
            let appDelegate = object as! AppDelegate
            appDelegate.memes.removeAtIndex(indexPath.row)
            // remove from current memes object
            memes.removeAtIndex(indexPath.row)
            memesTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
    
}
