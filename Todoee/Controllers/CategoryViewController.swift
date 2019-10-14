//
//  CategoryViewController.swift
//  Todoee
//
//  Created by Scott Bedard on 10/13/19.
//  Copyright © 2019 Scott Bedard. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: SwipeTableViewController {

    let realm = try! Realm()
    
    var categories : Results<Category>?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
    }

    // MARK - Table view data source
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let name = categories?[indexPath.row].name {
            cell.textLabel?.text = name == "" ? "No Categories added yet" : name
        } else {
            cell.textLabel?.text = "No Categories added yet"
        }
        
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categories?.count ?? 1
        
//        if let count = categories?.count {
//            return count == 0 ? 1 : count
//        } else {
//            return 1
//        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "todoItemSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as! TodoViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destVC.selectedCategory = categories?[indexPath.row]
        }
    }
    //MARK - Data Funcs
    func saveData(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error Saving Category: \(error)")
        }

        self.tableView.reloadData()
    }

    func loadData(){

        categories = realm.objects(Category.self)
        
        tableView.reloadData()
    }

    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = self.categories?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            } catch {
                print("Error Deleting Category: \(error)")
            }
        }
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {

        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add Category", message: "", preferredStyle: .alert)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create a new category"
            textField = alertTextField
        }
        
        alert.addAction(UIAlertAction(title: "Add Category", style: .default, handler: { (action) in
            
            if textField.text! != "" {
                let newCategory = Category()
                newCategory.name = textField.text!
                
                self.saveData(category: newCategory)
            }
        }))
        
        present(alert, animated: true, completion: nil)
    }
}
