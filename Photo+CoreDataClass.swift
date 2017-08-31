//
//  Photo+CoreDataClass.swift
//  VirtualTourist
//
//  Created by joel johnson on 8/30/17.
//  Copyright © 2017 joel johnson. All rights reserved.
//

import Foundation
import CoreData

@objc(Photo)
public class Photo: NSManagedObject {
    
    convenience init(index:Int, imageurl: String, image: NSData?, context: NSManagedObjectContext) {
        
        if let ent = NSEntityDescription.entity(forEntityName: "Photo", in: context) {
            
            self.init(entity: ent, insertInto: context)
            self.index = Int16(index)
            self.imageurl = imageurl
            self.image = image
            
        } else {
            fatalError("Unable To Find Entity Name!")
        }
    }
}
