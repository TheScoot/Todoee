//
//  TodoModel.swift
//  Todoee
//
//  Created by Scott Bedard on 10/12/19.
//  Copyright © 2019 Scott Bedard. All rights reserved.
//

import Foundation

class TodoItem: Codable {
    var todoName : String = ""
    var done: Bool = false
}
