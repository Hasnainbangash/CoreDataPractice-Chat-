//
//  ViewController.swift
//  CoreDataPractice(Chat)
//
//  Created by Elexoft on 16/12/2024.
//

import UIKit

class ChatController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    // Reference to Imanaged object context
    let context = PersistentStorage.shared.context
    
    // Data for the table
    var items: [User]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func addTapped(_ sender: Any) {
        // Create Alert
        let alert = UIAlertController(title: "Add Person", message: "What is their name?", preferredStyle: .alert)
        alert.addTextField()
        
        // Configure button handler
        let submitButton = UIAlertAction(title: "Add", style: .default) { (action) in
            
            // TODO: Get the textfield for the alert
            let textField = alert.textFields![0]
            
            // TODO: Create a person object
            let newUser = User(context: self.context)
            newUser.name = textField.text
            
            // TODO: Save the data
            do {
                try self.context.save()
            } catch {
                
            }
            
            // TODO: Re-fetch the data
            self.fetchPeople()
        }
        
        // Add button
        alert.addAction(submitButton)
        
        // Show alert
        self.present(alert, animated: true, completion: nil)
    }
    
}



extension ChatController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
}
