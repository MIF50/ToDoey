//
//  Item.swift
//  ToDoey
//
//  Created by BeInMedia on 8/10/19.
//  Copyright © 2019 MIF50. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String =  ""
    @objc dynamic var done: Bool = false
    @objc dynamic var createdAt: NSDate = NSDate()
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
