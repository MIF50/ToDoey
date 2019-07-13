//
//  ViewController.swift
//  ToDoey
//
//  Created by BeInMedia on 6/25/19.
//  Copyright © 2019 MIF50. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item()]
    
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.separatorStyle = .none
        
        let item = Item()
        item.title = "Find Mike"
        item.done  = true
        itemArray.append(item)
        
        let item2 = Item()
        item2.title = "Bug Eggos"
        itemArray.append(item2)
        
        
        let item3 = Item()
        item3.title = "Destory Demogorgon"
        itemArray.append(item3)
        
        if let items = defaults.array(forKey: "TodoItemArray") as? [Item]{
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
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        // ternary operator
        // value = condition ? valueIfTrue : valueIfFalse
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    //MARK: TableView delegate methods
    
    // Tell the delegate that the specified row is now selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(itemArray[indexPath.row])
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        tableView.reloadData()
        
//        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//        } else {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    //MARK: Add New Item
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add New Todo Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what will happen once the user clicks the Add Item button on our UIAlert
            
            
            let textField = alert.textFields![0] as UITextField
            guard let newItemArray = textField.text else { return }
            let newItem = Item()
            newItem.title = newItemArray
            self.itemArray.append(newItem)
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

