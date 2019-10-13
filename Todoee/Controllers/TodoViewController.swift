//
//  TodoViewController.swift
//  Todoee
//
//  Created by Scott Bedard on 10/12/19.
//  Copyright © 2019 Scott Bedard. All rights reserved.
//

import UIKit
import CoreData

class TodoViewController: UITableViewController {

    var itemArray = [TodoItem]()
//    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("TodoItems.plist")
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadData()
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
        
        tableView.deselectRow(at: indexPath, animated: true)

        saveData()
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
                let newTodo = TodoItem(context: self.context)
                newTodo.todoName = textField.text!
                newTodo.done = false
                self.itemArray.append(newTodo)
                
                self.saveData()
            }
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    func saveData() {
        do {
            try context.save()
        } catch {
            print("Error Saving Todos: \(error)")
        }

        self.tableView.reloadData()
    }
    
    func loadData(with request: NSFetchRequest<TodoItem> = TodoItem.fetchRequest()){
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error Loading Data: \(error)")
        }

        tableView.reloadData()
    }
}

//MARK - Search Delegate

extension TodoViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        let request : NSFetchRequest<TodoItem> = TodoItem.fetchRequest()
        request.predicate = NSPredicate(format: "todoName CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "todoName", ascending: true)]
        
        loadData(with: request)
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
