//
//  SettingsViewController.swift
//  MemeMe
//
//  Created by Patrick Montalto on 4/4/16.
//  Copyright © 2016 swift. All rights reserved.
//

import Foundation
import UIKit

class SettingsViewController: UIViewController {
    
    var textFieldFont: String = "Impact"
    
    let availableFonts = ["Impact", "Helvetica"]
    
    @IBAction func goBack(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    

    // function to set MemeEditorViewController's textFieldFont
    // function to set MemeEditorViewController's textFieldFontSize
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let controller = segue.destinationViewController as! MemeEditorViewController
        
        controller.textFieldFont = self.textFieldFont
    }
}
