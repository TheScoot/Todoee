//
//  TodoViewController.swift
//  Todoee
//
//  Created by Scott Bedard on 10/12/19.
//  Copyright © 2019 Scott Bedard. All rights reserved.
//

import UIKit
import RealmSwift

class TodoViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    var selectedCategory : Category? {
        didSet{
            loadData()
        }
    }
    
    var todoItems : Results<TodoItem>?
    
    //    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("TodoItems.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)

        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.todoName
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items in Category yet"
            cell.accessoryType = .none
        }
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return todoItems?.count ?? 1
    }
    
    //MARK - Tableview Delegates
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error Updating Todo: \(error)")
            }
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.tableView.reloadData()
        
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
                if let currentCategory = self.selectedCategory {
                    do {
                        try self.realm.write {
                            let newTodo = TodoItem()
                            newTodo.todoName = textField.text!
                            newTodo.dateCreated = Date()
                            currentCategory.todoItems.append(newTodo)
                        }
                    } catch {
                        print("Error Saving Todos: \(error)")
                    }
                    
                    self.tableView.reloadData()
                }
            }
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    func loadData(){
        
        todoItems = selectedCategory?.todoItems.sorted(byKeyPath: "todoName", ascending: true)
        
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let todoForDeletion = self.todoItems?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(todoForDeletion)
                }
            } catch {
                print("Error Deleting Todo: \(error)")
            }
        }
    }
    
}

//MARK - Search Delegate

extension TodoViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("todoName CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text!.count == 0 {
            loadData()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
