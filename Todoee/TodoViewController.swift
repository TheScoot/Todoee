//
//  TodoViewController.swift
//  Todoee
//
//  Created by Scott Bedard on 10/12/19.
//  Copyright © 2019 Scott Bedard. All rights reserved.
//

import UIKit

class TodoViewController: UITableViewController {

    let itemArray = ["Home Depot", "Walgreens", "Safeway"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let returnCell = tableView.dequeueReusableCell(withIdentifier: "todoItemCell", for: indexPath)
        
        returnCell.textLabel?.text = itemArray[indexPath.row]
        
        return returnCell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
    }

    //MARK - Tableview Delegates
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
}

