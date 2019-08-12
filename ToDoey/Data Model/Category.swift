//
//  Category.swift
//  ToDoey
//
//  Created by BeInMedia on 8/10/19.
//  Copyright © 2019 MIF50. All rights reserved.
//

import Foundation
import RealmSwift
class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
}
