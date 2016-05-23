//
//  Meme.swift
//  MemeMe
//
//  Created by Patrick Montalto on 4/4/16.
//  Copyright © 2016 swift. All rights reserved.
//

// Import CoreData
import CoreData
import UIKit

// MARK: - Meme: NSManagedObject
class Meme: NSManagedObject {
    
    // MARK: - Keys 
    struct Keys {
        static let TopText = "topText"
        static let BottomText = "bottomText"
        static let ImagePath = "imagePath"
        static let MemedImagePath = "memedImagePath"
        static let fontName = "fontName"
    }
    
    // MARK: - Properties
    // promote basic properties to core data attributes
    @NSManaged var topText: String
    @NSManaged var bottomText: String
    @NSManaged var imagePath: String
    @NSManaged var memedImagePath: String
    @NSManaged var fontName: String
    
    // MARK: - Standard Core Data init method
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    // MARK: - Two argument init method
    init(dictionary: [String:AnyObject], context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entityForName("Meme", inManagedObjectContext: context)!
        
        // call to super.init to insert entity into context
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        // set properties
        topText = dictionary[Keys.TopText] as! String
        bottomText = dictionary[Keys.BottomText] as! String
        fontName = dictionary[Keys.fontName] as! String
        imagePath = dictionary[Keys.ImagePath] as! String
        memedImagePath = dictionary[Keys.MemedImagePath] as! String
    
    }
    
    
    var image: UIImage? {
        get { return ImageCacher.sharedCacher().imageWithIdentifier(imagePath) }
        set { ImageCacher.sharedCacher().storeImage(newValue, withIdentifier: imagePath) }
    }
    
    var memedImage: UIImage? {
        get { return ImageCacher.sharedCacher().imageWithIdentifier(memedImagePath) }
        set { ImageCacher.sharedCacher().storeImage(newValue, withIdentifier: memedImagePath)}
    }
}