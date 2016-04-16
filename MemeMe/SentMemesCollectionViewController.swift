//
//  SentMemesCollectionViewController.swift
//  MemeMe
//
//  Created by Patrick Montalto on 4/8/16.
//  Copyright © 2016 swift. All rights reserved.
//

import UIKit

class SentMemesCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var memes = [Meme]()
    
    @IBOutlet var memeCollectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let space: CGFloat = 0
        let dimension = (view.frame.size.width)/2.0
        
        flowLayout.minimumLineSpacing = space
        flowLayout.minimumInteritemSpacing = space
        flowLayout.itemSize = CGSizeMake(dimension, dimension)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        memes = appDelegate.memes
        memeCollectionView.reloadData()
    }
    
    // looking for an alternative way to size cells properly:
    
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
//        var totalHeight: CGFloat = (self.view.frame.height) / 3
//        var totalWidth: CGFloat = (self.view.frame.width) / 3
//        print("The frame width is: \(self.view.frame.width)")
//        print("The total width is: \(totalWidth)")
//        return CGSizeMake(totalWidth, totalWidth)
//    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        // return the meme
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCollectionViewCell", forIndexPath: indexPath) as! MemeCollectionViewCell
        let meme = memes[indexPath.row]
        
        cell.memeImageView?.image = meme.image
        setTextAttributes(cell, meme: meme)
        print("Cell width: \(cell.bounds.width)")
        print("Cell height: \(cell.bounds.height)")
        print("image width: \(cell.memeImageView.bounds.width)")
        print("image height: \(cell.memeImageView.bounds.height)")
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
