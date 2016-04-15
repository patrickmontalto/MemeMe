//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Patrick Montalto on 4/8/16.
//  Copyright © 2016 swift. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    
    @IBOutlet var memeImage: UIImageView!
    
    var meme: Meme!
    
    override func viewWillAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        // set the memed image and hide the tab bar
        memeImage?.image = meme.memedImage
        tabBarController?.tabBar.hidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewDidDisappear(true)
        // unhide the tab bar
        tabBarController?.tabBar.hidden = false
        
    }
    
}
