//
//  ViewController.swift
//  poly-paint-ios
//
//  Created by Eric Sida Li on 2018-09-22.
//  Copyright © 2018 PolyAcme. All rights reserved.
//

import UIKit
import SocketIO

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    @IBOutlet weak var messageTableView: UITableView!
    var messagesArray = [String]()
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var dockViewHeightConstraint: NSLayoutConstraint!
    
    var manager:SocketManager!
    
    var socketIOClient: SocketIOClient!
    
    func ConnectToSocket() {
        
        manager = SocketManager(socketURL: URL(string: "http://localhost:3000")!, config: [.log(true), .compress])
        socketIOClient = manager.defaultSocket
        
        socketIOClient.on(clientEvent: .connect) {data, ack in
            print(data)
            print("socket connected")
        }
        
        socketIOClient.on(clientEvent: .error) { (data, eck) in
            print(data)
            print("socket error")
        }
        
        socketIOClient.on(clientEvent: .disconnect) { (data, eck) in
            print(data)
            print("socket disconnect")
        }
        
        socketIOClient.on(clientEvent: SocketClientEvent.reconnect) { (data, eck) in
            print(data)
            print("socket reconnect")
        }
        
        socketIOClient.connect()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.messageTableView.delegate = self
        self.messageTableView.dataSource = self
        
        // Set as delegate for the textfield
        self.messageTextField.delegate = self
        
        // Add some sample data so that we can see something
        messagesArray.append("Test 1")
        messagesArray.append("Test 2")
        messagesArray.append("Test 3")
        ConnectToSocket()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        hideKeyboard()
    }
    
    func hideKeyboard() {
        self.view.endEditing(true)
        view.layoutIfNeeded()
        UIView.animate(withDuration: 0.1, animations: {
            self.dockViewHeightConstraint.constant = 60
            self.view.layoutIfNeeded()
        }, completion: nil)
    }

    @IBAction func sendButtonTap(_ sender: UIButton) {
        socketIOClient.emit("message", messageTextField.text!)
        hideKeyboard()
    }
    
    // MARK: TextField Delegate Methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        hideKeyboard()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        view.layoutIfNeeded()
        UIView.animate(withDuration: 0.1, animations: {
            self.dockViewHeightConstraint.constant = 400
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        hideKeyboard()
    }
    
    // MARK: TableView Delegate Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messagesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Create a table cell
        guard let cell = messageTableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as? UITableViewCell else {
            fatalError("Could not dequeue UITableViewCell")
        }
        
        // Customize the cell
        cell.textLabel?.text = messagesArray[indexPath.row]
        
        // Return the cell
        return cell
    }
}

