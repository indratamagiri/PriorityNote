//
//  Tasks+CoreDataProperties.swift
//  NoName
//
//  Created by giri on 6/11/18.
//  Copyright © 2018 Bianka. All rights reserved.
//
//

import Foundation
import CoreData


extension Tasks {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tasks> {
        return NSFetchRequest<Tasks>(entityName: "Tasks")
    }

    @NSManaged public var id: String?
    @NSManaged public var title: String?
    @NSManaged public var des: String?
    @NSManaged public var time: NSDate?
    @NSManaged public var status: Bool

}
