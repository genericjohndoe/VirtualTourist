//
//  Photo+CoreDataProperties.swift
//  VirtualTourist
//
//  Created by joel johnson on 8/30/17.
//  Copyright © 2017 joel johnson. All rights reserved.
//

import Foundation
import CoreData


extension Photo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo")
    }

    @NSManaged public var image: NSData?
    @NSManaged public var imageurl: String?
    @NSManaged public var index: Int16
    @NSManaged public var pin: Pin?

}
