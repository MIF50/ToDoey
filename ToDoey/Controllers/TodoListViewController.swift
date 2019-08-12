//
//  ViewController.swift
//  ToDoey
//
//  Created by BeInMedia on 6/25/19.
//  Copyright © 2019 MIF50. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {
    
    var realm = try! Realm()
    var todoItems: Results<Item>?
    
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
    }
    
    //MARK:- TableView DataSource Methods
    
    // Return the number of rows in the table
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    // Provide a cell object for each row.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell",for: indexPath)
        // configure the cell's contents.
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Item in Selecet Category"
        }
        return cell
    }
    
    //MARK: TableView delegate methods
    
    // Tell the delegate that the specified row is now selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // update data with realm
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("error update item done \(error)")
            }
        }
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    //MARK: Add New Item
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add New Todo Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what will happen once the user clicks the Add Item button on our UIAlert
            
            let textField = alert.textFields![0] as UITextField
            guard let titleItem = textField.text else { return }
            let newItem = Item()
            newItem.title = titleItem
            self.save(with: newItem)
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
        }
        alert.addAction(action)
        alert.view.layoutIfNeeded() // avoid Snapshotting error
        present(alert, animated: true, completion: nil)
    }
    
    //MASK: add new Item
    func save(with item: Item){
        if let currentCategory = self.selectedCategory {
            do {
                try realm.write {
                    currentCategory.items.append(item)
                }
            } catch {
                print("error added new item \(error)")
            }
        }
        
        tableView.reloadData()
    }
    
    func loadItems(){
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
}

//MARK: - Search bar methods

extension TodoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchTextEnterd = searchBar.text {
            todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchTextEnterd)
            .sorted(byKeyPath: "createdAt", ascending: false)
            tableView.reloadData()
        }
       
    }


    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text!.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}


