//
//  ViewController.swift
//  MemeMe
//
//  Created by Patrick Montalto on 4/3/16.
//  Copyright © 2016 swift. All rights reserved.
//

import UIKit

// Need to inherit from UIImagePickerControllerDelegate and UINavgiationControllerDelegate for UIImagePicker

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet var topTextField: UITextField!
    @IBOutlet var bottomTextField: UITextField!
    @IBOutlet var imagePickerView: UIImageView!
    @IBOutlet var toolbar: UIToolbar!
    @IBOutlet var shareButton: UIBarButtonItem!
    @IBOutlet var navbar: UINavigationItem!
    @IBOutlet var cancelButton: UIBarButtonItem!
    @IBOutlet var cameraButton: UIBarButtonItem!
    
    var textFieldFont: String?
    
    // View lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hide status bar for full-screen app
        UIApplication.sharedApplication().statusBarHidden = true
        
        // Create dictionary of text attributes for meme textfields
        let memeTextAttributes = [
            NSStrokeColorAttributeName: UIColor.blackColor(),
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName: -5.0
        ]
        
        // Set the default text attributes in textfields
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
        
        // Position text in center of textfields
        topTextField.textAlignment = NSTextAlignment.Center
        bottomTextField.textAlignment = NSTextAlignment.Center
        
        // Set default text and disable share button
        prepareDefaultState()
        
        // Toggle the cameraButton if the device has a usable camera
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
        // Set bottom textfield delegate
        topTextField.delegate = self
        bottomTextField.delegate = self
        
        // Remove borders on textfields
        topTextField.borderStyle = UITextBorderStyle.None
        bottomTextField.borderStyle = UITextBorderStyle.None
        
        // Set textfield font if it is selected
        if let fontName = textFieldFont {
            topTextField.font = UIFont(name: fontName, size: 14)
        }
        
    }
    
    func prepareDefaultState() {
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        shareButton.enabled = false
        imagePickerView.image = nil
    }
    
    // Textfield methods
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField.tag == 1 {
            subscribeToKeyboardNotifications()
        }
        if ["TOP", "BOTTOM"].contains(textField.text!) {
            textField.text = nil
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField.tag == 1 {
            unsubscribeFromKeyboardNotifications()
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    @IBAction func pickAnImage(sender: AnyObject) {
        // Instantiate the image picker controller and present
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        // pickerController.allowsEditing = true
        self.presentViewController(pickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        // Conditionally select original image selected
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            imagePickerView.image = image
        }
        // Enable share button
        shareButton.enabled = true
        // Dismiss image picker on image pick
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        // Dismiss image picker on cancel button selected
        dismissViewControllerAnimated(true, completion: nil)
    }

    func keyboardWillShow(notification: NSNotification) {
        view.frame.origin.y -= getKeyboardHeight(notification)
    }
    
    func keyboardWillHide(notification: NSNotification) {
        view.frame.origin.y += getKeyboardHeight(notification)
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        
        return keyboardSize.CGRectValue().height

    }
    
    @IBAction func share(sender: AnyObject) {
        let memedImage = generateMemedImage()
        let activityViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        activityViewController.completionWithItemsHandler = {
            (activityType, completed, items, error) in
            self.saveMeme(memedImage)
        }
        presentViewController(activityViewController, animated: true, completion: nil)
    }
    
    func saveMeme(memedImage: UIImage) {
        // Create the meme
        if let topText = topTextField.text, bottomText = bottomTextField.text, image = imagePickerView.image {
            _ = Meme(topText: topText, bottomText: bottomText, image: image, memedImage: memedImage)
        }
    }
    
    func generateMemedImage() -> UIImage {
        // TODO: Hide navbar
        self.toolbar.hidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // TODO: Show navbar
        self.toolbar.hidden = false
        return memedImage
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MemeEditorViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MemeEditorViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    @IBAction func cancelMeme(sender: AnyObject) {
        prepareDefaultState()
    }
    
    @IBAction func takeAnImage(sender: AnyObject) {
        // Instantiate a camera view controller
        let cameraViewController = UIImagePickerController()
        cameraViewController.sourceType = UIImagePickerControllerSourceType.Camera
        cameraViewController.delegate = self
        //cameraViewController.allowsEditing = true
        presentViewController(cameraViewController, animated: true, completion: nil)
    }
    
    
    // TODO: Enable multiline text fields for bottom and top?
    
    // TODO: Disable Cancel button if top text field and bottom textfield is TOP and BOTTOM and no image is picked - or inverse: only enable if fields have text etc
    
    // TODO: Add settings button to change font faces. List 3 font faces available
    // have 3 font face settings slide out from right side
    
    
    
}

