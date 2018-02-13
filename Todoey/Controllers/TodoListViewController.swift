//
//  ViewController.swift
//  Todoey
//
//  Created by Taiwo on 22/01/2018.
//  Copyright © 2018 Taiwo. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {

    var todoItems: Results<Item>?

    let realm = try! Realm()

    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    //MARK:- TableView Datasource Methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (todoItems?.count)!
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)

        let item = todoItems?[indexPath.row]

        cell.textLabel?.text = item?.title

        cell.accessoryType = (item?.done)! ? .checkmark : .none

        return cell
    }

    //MARK: - TableView Delegate Methods

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        try? realm.write {

            todoItems![indexPath.row].done = !(todoItems?[indexPath.row].done)!
        }

        tableView.reloadData()
    }

    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {

        var textField = UITextField()

        let alert = UIAlertController(title: "Add New Todo", message: "", preferredStyle: .alert)

        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in

            if let category = self.selectedCategory {

                do {
                    try self.realm.write {

                        let newItem = Item()

                        newItem.title = textField.text!

                        newItem.dateCreated = Date()

                        category.items.append(newItem)

                        self.loadItems()
                    }
                } catch {
                    print ("An error occurred saving new item: \(error)")
                }
            }
        }

        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            alertTextField.autocapitalizationType = .sentences
            textField = alertTextField
        }

        alert.addAction(action)

        present(alert, animated: true, completion: nil)
    }

    //MARK:- Custom Methods

    func loadItems() {

        todoItems = selectedCategory?.items.sorted(byKeyPath: "dateCreated", ascending: false)

        tableView.reloadData()
    }
}

extension TodoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        todoItems = todoItems?.filter("title CONTAINS [cd] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true)

        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        if searchBar.text?.count == 0 {
            loadItems()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }

}
