//
//  MessageController.swift
//  CoreDataPractice(Chat)
//
//  Created by Elexoft on 16/12/2024.
//

import UIKit
import CoreData

class MessageController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    
    // Reference to Imanaged object context
    let context = PersistentStorage.shared.context
    
    // Data for the table
    var items: [Message]?
    var userID: UUID?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.dataSource = self
        
        if let userId = userID {
            fetchMessages()
        }
    }
    
    func fetchMessages() {
        do {
            // Create a fetch request for Message
            let request: NSFetchRequest<Message> = Message.fetchRequest()

            if let userID = userID {
                let predicate = NSPredicate(format: "userId == %@", userID as CVarArg)
                request.predicate = predicate
            }
            
            // Perform the fetch request
            self.items = try context.fetch(request)
            
            // Reload the table view
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            print("Error fetching messages: \(error)")
        }
    }

    
    @IBAction func sendButton(_ sender: UIButton) {
        if let messageText = messageTextField.text {
            let newMessage = Message(context: self.context)
            newMessage.id = UUID()
            newMessage.messages = messageText
            newMessage.userId = userID
            
            PersistentStorage.shared.saveContext()
            
            fetchMessages()
        }
    }
    
}

extension MessageController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.Identifiers.messageCellIdentifier, for: indexPath) as? MessageCell
        
        let message = items?[indexPath.row]
        cell?.messageLabel.text = message?.messages
        
        return cell ?? UITableViewCell()
    }
}
