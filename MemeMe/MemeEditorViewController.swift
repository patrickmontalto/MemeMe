//
//  ViewController.swift
//  MemeMe
//
//  Created by Patrick Montalto on 4/3/16.
//  Copyright © 2016 swift. All rights reserved.
//

// Import Core Data
import CoreData
import UIKit

// Need to inherit from UIImagePickerControllerDelegate and UINavgiationControllerDelegate for UIImagePicker

// Delegate
protocol MemeEditorViewControllerDelegate {
    func memeEditor(memeEditor: MemeEditorViewController, didSaveMeme meme: Meme?)
}

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet var topTextField: UITextField!
    @IBOutlet var bottomTextField: UITextField!
    @IBOutlet var imagePickerView: UIImageView!
    @IBOutlet var toolbar: UIToolbar!
    @IBOutlet var shareButton: UIBarButtonItem!
    @IBOutlet var cancelButton: UIBarButtonItem!
    @IBOutlet var cameraButton: UIBarButtonItem!
    
    // The delegate will typically be a view controller, waiting for the Meme Editor
    // to return a Meme
    var delegate: MemeEditorViewControllerDelegate?
    
    @IBOutlet var memeEditorNavigationBar: UINavigationBar!
    var textFieldFont = "Impact"
    
    // View lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hide status bar for full-screen app
        UIApplication.sharedApplication().statusBarHidden = true
        
        // Create dictionary of text attributes for meme textfields
        let memeTextAttributes = [
            NSStrokeColorAttributeName: UIColor.blackColor(),
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSStrokeWidthAttributeName: -5.0
        ]
        
        // Set the default text attributes in textfields
        setAttributesForTextField(topTextField, textAttributes: memeTextAttributes)
        setAttributesForTextField(bottomTextField, textAttributes: memeTextAttributes)
        
        // Set default text and disable share button
        prepareDefaultState()
        
        // Toggle the cameraButton if the device has a usable camera
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // Set top and bottom textfield fonts
        topTextField.font = UIFont(name: textFieldFont, size: 40)
        bottomTextField.font = UIFont(name: textFieldFont, size: 40)
        
    }
    
    func prepareDefaultState() {
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        shareButton.enabled = false
        imagePickerView.image = nil
    }
    
    func setAttributesForTextField(textField: UITextField, textAttributes: [String: AnyObject]) {
        textField.defaultTextAttributes = textAttributes
        textField.textAlignment = NSTextAlignment.Center
        textField.delegate = self
        textField.borderStyle = UITextBorderStyle.None
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
        
        // Set sourcetype to camera if the camera button calls this function
        if sender as! NSObject == cameraButton {
            pickerController.sourceType = UIImagePickerControllerSourceType.Camera
        }
        
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
        view.frame.origin.y = getKeyboardHeight(notification) * -1
    }
    
    func keyboardWillHide(notification: NSNotification) {
        view.frame.origin.y = 0
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
                if completed {
                    self.saveMeme(memedImage)
                }
        }
        presentViewController(activityViewController, animated: true, completion: nil)
    }
    
    func saveMeme(memedImage: UIImage) {
        if let topText = topTextField.text, bottomText = bottomTextField.text, image = imagePickerView.image {
            // create imagePath and memedImagePath
            let imagePath = "\(NSDate().timeIntervalSince1970)"
            let memedImagePath = "\(NSDate().timeIntervalSince1970)"
            
            // Create the meme dictionary and save meme
            let memeDictionary = [Meme.Keys.TopText: topText, Meme.Keys.BottomText:bottomText, Meme.Keys.ImagePath: imagePath, Meme.Keys.MemedImagePath: memedImagePath, Meme.Keys.fontName: textFieldFont]
            
            let meme = Meme(dictionary: memeDictionary, context: sharedContext)
            
            meme.image = image
            meme.memedImage = memedImage
            
            delegate?.memeEditor(self, didSaveMeme: meme)
        }
    }
    
    func generateMemedImage() -> UIImage {
        self.toolbar.hidden = true
        memeEditorNavigationBar.hidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.toolbar.hidden = false
        memeEditorNavigationBar.hidden = false
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
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let secondViewController = segue.destinationViewController as! SettingsViewController
        
        secondViewController.firstViewController = self

    }
    
    // MARK: - Core Data Convenience
    lazy var sharedContext: NSManagedObjectContext = {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }()
    
}

