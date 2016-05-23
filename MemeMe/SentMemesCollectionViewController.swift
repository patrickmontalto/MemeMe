//
//  SentMemesCollectionViewController.swift
//  MemeMe
//
//  Created by Patrick Montalto on 4/8/16.
//  Copyright © 2016 swift. All rights reserved.
//

import UIKit
import CoreData

class SentMemesCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var memes = [Meme]()
    
    @IBOutlet var memeCollectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let space: CGFloat = 0
        let dimension = (view.frame.size.width)/3.0
        
        flowLayout.minimumLineSpacing = space
        flowLayout.minimumInteritemSpacing = space
        flowLayout.itemSize = CGSizeMake(dimension, dimension)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        let tabBarController = self.tabBarController as! MemeTabBarController
        memes = tabBarController.memes
        memeCollectionView.reloadData()
    }
    
    @IBAction func addMeme(sender: AnyObject) {
        let controller = storyboard!.instantiateViewControllerWithIdentifier("MemeEditorViewController") as! MemeEditorViewController
            
        controller.delegate = self
            
        self.presentViewController(controller, animated: true, completion: nil)

    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        // return the meme
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCollectionViewCell", forIndexPath: indexPath) as! MemeCollectionViewCell
        let meme = memes[indexPath.row]
        
        cell.memeImageView?.image = meme.image
        setTextAttributes(cell, meme: meme)
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // present meme detail view controller
        let detailController = storyboard?.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        detailController.meme = memes[indexPath.row]
        navigationController?.pushViewController(detailController, animated: true)
    }
    
    func setTextAttributes(cell: MemeCollectionViewCell, meme: Meme) {
        
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
    
}

// MARK: - MemeEditorViewController Delegate
extension SentMemesCollectionViewController: MemeEditorViewControllerDelegate {
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
