//
//  TodoViewController.swift
//  Todoee
//
//  Created by Scott Bedard on 10/12/19.
//  Copyright © 2019 Scott Bedard. All rights reserved.
//

import UIKit

class TodoViewController: UITableViewController {

    var itemArray = [TodoItem]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("TodoItems.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let data = try? Data(contentsOf: dataFilePath!){
            let deencoder = PropertyListDecoder()
            do {
                itemArray = try deencoder.decode([TodoItem].self, from: data)
            } catch {
                print("Error Loading Data: \(error)")
            }
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let returnCell = tableView.dequeueReusableCell(withIdentifier: "todoItemCell", for: indexPath)
        
        returnCell.textLabel?.text = itemArray[indexPath.row].todoName
        
        returnCell.accessoryType = itemArray[indexPath.row].done ? .checkmark : .none
        
        return returnCell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
    }

    //MARK - Tableview Delegates
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveData()
        
        tableView.deselectRow(at: indexPath, animated: true)

        tableView.reloadData()

    }
    
    //Mark - Add Todo Items
    
    @IBAction func buttonBarItemPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add Todoee Item", message: "", preferredStyle: .alert)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create a new todo item"
            textField = alertTextField
        }
        
        alert.addAction(UIAlertAction(title: "Add Todo Item", style: .default, handler: { (action) in
            
            if textField.text! != "" {
                let newTodo = TodoItem()
                newTodo.todoName = textField.text!
                self.itemArray.append(newTodo)
                
                self.saveData()
                
                self.tableView.reloadData()
            }
        }))
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func saveData() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("Error Saving Todos: \(error)")
        }
    }
}

