//
//  ViewController.swift
//  CoreDataPractice(Chat)
//
//  Created by Elexoft on 16/12/2024.
//

import UIKit
import CoreData

class ChatController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    // Reference to Imanaged object context
    let context = PersistentStorage.shared.context
    
    // Data for the table
    var items: [User]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.dataSource = self
        tableView.delegate = self
        
        fetchUsers()
    }
    
    func fetchUsers() {
        // Fetch the data from Core Data to display in the tableview
        do {
            
            let request = User.fetchRequest() as NSFetchRequest<User>
            
            self.items = try context.fetch(request)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        } catch {
            
        }
    }
    
    @IBAction func addTapped(_ sender: Any) {
        // Create Alert
        let alert = UIAlertController(title: "Add User", message: "What is their name?", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Enter Username"
            textField.autocapitalizationType = .words
        }
        
        // Configure button handler
        let submitButton = UIAlertAction(title: "Add", style: .default) { (action) in
            
            // TODO: Get the textfield for the alert
            let textField = alert.textFields?[0]
            
            // TODO: Create a person object
            let newUser = User(context: self.context)
            newUser.name = textField?.text
            newUser.id = UUID()
            
            // TODO: Save the data
            PersistentStorage.shared.saveContext()
            
            // TODO: Re-fetch the data
            self.fetchUsers()
        }
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            print("Cancel Button is clicked")
        }
        
        // Add button
        alert.addAction(submitButton)
        alert.addAction(cancelButton)
        
        // Show alert
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension ChatController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.Identifiers.chatCellIdentifier, for: indexPath) as? ChatCell
        
        let user = self.items?[indexPath.row]
        
        cell?.nameLabel.text = user?.name
        
        return cell ?? UITableViewCell()
    }
}

extension ChatController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let user = items?[indexPath.row]
        performSegue(withIdentifier: K.Segues.chatToMessageSegue, sender: self)
        
        // Deselect the row after selecting it
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let action = UIContextualAction(style: .destructive, title: "Delete") { action, view, completionHandler in
            
            // TODO: Which person to remove
            let userToRemove = self.items![indexPath.row]
            
            // TODO: Remove the person
            self.context.delete(userToRemove)
            
            // TODO: Save the data
            PersistentStorage.shared.saveContext()
            
            // TODO: Re-fetch the data
            self.fetchUsers()
            
        }
        
        return UISwipeActionsConfiguration(actions: [action])
    }
}
