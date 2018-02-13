//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Taiwo on 04/02/2018.
//  Copyright © 2018 Taiwo. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {

    var categories: Results<Category>?

    let realm = try! Realm()

    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategories()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return categories?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)

        let category = categories?[indexPath.row]

        cell.textLabel?.text = category?.name

        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        let destination  = segue.destination as! TodoListViewController

        if let indexPath = tableView.indexPathForSelectedRow {
            destination.selectedCategory = categories?[indexPath.row]
        }
    }

    //MARK: - Table view delegate methods

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        performSegue(withIdentifier: "goToItems", sender: self)
    }

    //MARK: - Data Manipulation Methods

    func loadCategories() {

        categories = realm.objects(Category.self)

        tableView.reloadData()
    }

    func save(category: Category) {  
        
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print ("Can't save context: \(error)")
        }

        tableView.reloadData()
    }


    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {

        var textField = UITextField()

        let alert = UIAlertController(title: "Add Todo Category", message: "", preferredStyle: .alert)

        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in

            let newCategory = Category()
            newCategory.name = textField.text!

            self.save(category: newCategory)
        }

        alert.addAction(action)
        alert.addTextField { (alertTextField) in
            alertTextField.autocapitalizationType = .sentences
            textField = alertTextField
        }

        present(alert, animated: true, completion: nil)
    }

}
