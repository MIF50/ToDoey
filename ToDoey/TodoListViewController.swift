//
//  ViewController.swift
//  ToDoey
//
//  Created by BeInMedia on 6/25/19.
//  Copyright © 2019 MIF50. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = ["Find Mike", "Bug Eggos", "Destory Demogorgon"]
    
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.separatorStyle = .none
        if let items = defaults.array(forKey: "TodoItemArray") as? [String]{
            itemArray = items
        }
    }
    
    //MARK:- TableView DataSource Methods
    
    // Return the number of rows in the table
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    // Provide a cell object for each row.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell",for: indexPath)
        // configure the cell's contents.
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
    }
    
    //MARK: TableView delegate methods
    
    // Tell the delegate that the specified row is now selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(itemArray[indexPath.row])
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    //MARK: Add New Item
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add New Todo Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what will happen once the user clicks the Add Item button on our UIAlert
            
            let textField = alert.textFields![0] as UITextField
            guard let newItemArray = textField.text else { return}
            
            self.itemArray.append(newItemArray)
            self.defaults.setValue(self.itemArray, forKey: "TodoItemArray")
            self.tableView.reloadData()
            
            
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}

