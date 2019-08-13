//
//  CategoryViewController.swift
//  ToDoey
//
//  Created by BeInMedia on 8/2/19.
//  Copyright © 2019 MIF50. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        loadCategories()
        
    }
    private func updateUI() {
        tableView.separatorStyle = .none
    }
    
    
    //MARK: - TableView Datasource Methods
    
    //Return the number of rows in the table
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    // Provide a cell object for each row.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        // configure cell's contents.
        let category = categories?[indexPath.row]
        cell.textLabel?.text = category?.name ?? "No Category Added yet"
        guard let categoryColor = UIColor(hexString: category?.color ?? "#FFFFFF") else {fatalError()}
        cell.backgroundColor = categoryColor
        cell.textLabel?.textColor = ContrastColorOf(categoryColor, returnFlat: true)
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToItems" {
            let destinationVC = segue.destination as! TodoListViewController
            if let indexPath = tableView.indexPathForSelectedRow?.row {
                destinationVC.selectedCategory = categories?[indexPath]
            }
        }
    }
    
    
    //MARK: - Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            // what will happen once the user clicks the Add Category button on our UIAlert
            let textField = alert.textFields![0] as UITextField
            guard let categoryName = textField.text else { return }
            let newCategory = Category()
            newCategory.name = categoryName
            newCategory.color = UIColor.randomFlat.hexValue()
            print("Color set is \(newCategory.color)")
            self.save(category:  newCategory)
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add a new Category"
        }
        
        alert.addAction(action)
        alert.view.layoutIfNeeded() // avoid Snapshotting error 
        present(alert,animated: true, completion: nil)
        
    }
    
    // MARK: - Data Mainpulation Methods
    
    func save(category: Category){
        do{
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("error save categoies array \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategories(){
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = categories?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(categoryForDeletion)
                }
            } catch {
                print("Error deteting category \(error)")
            }
        }
        
    }
    
}


