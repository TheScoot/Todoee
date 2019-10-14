//
//  Category.swift
//  Todoee
//
//  Created by Scott Bedard on 10/13/19.
//  Copyright © 2019 Scott Bedard. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
    let todoItems = List<TodoItem>()
}
