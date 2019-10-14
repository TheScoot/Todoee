//
//  TodoItem.swift
//  Todoee
//
//  Created by Scott Bedard on 10/13/19.
//  Copyright © 2019 Scott Bedard. All rights reserved.
//

import Foundation
import RealmSwift

class TodoItem : Object {
    @objc dynamic var todoName : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated : Date?
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "todoItems")
}
