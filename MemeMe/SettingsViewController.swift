//
//  SettingsViewController.swift
//  MemeMe
//
//  Created by Patrick Montalto on 4/4/16.
//  Copyright © 2016 swift. All rights reserved.
//

import Foundation
import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var firstViewController: UIViewController?
    
    var selectedRow = Int()
    
    var textFieldFont: String?
    
    let availableFonts = ["Impact", "Helvetica", "Futura"]
    
    @IBOutlet weak var textSelectTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get selectedRow based on textFieldFont variable on MemeEditorViewController
        let previousController = firstViewController as! MemeEditorViewController
        selectedRow = availableFonts.indexOf(previousController.textFieldFont)!
        
        textSelectTable.delegate = self
        textSelectTable.dataSource = self
    }
    
    @IBAction func goBack(sender: AnyObject) {
        if let textfieldFont = textFieldFont {
            let previousController = firstViewController as! MemeEditorViewController
            previousController.textFieldFont = self.textFieldFont!
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return availableFonts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        cell.textLabel?.text = availableFonts[indexPath.row]
        if indexPath.row == selectedRow {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        textFieldFont = availableFonts[indexPath.row]
        selectedRow = indexPath.row
        tableView.reloadData()
    }
    
}
