//
//  ViewController.swift
//  ToDoList
//
//  Created by Sandu on 1/6/22.
//  Copyright © 2022 Sandu. All rights reserved.
//

import UIKit


protocol ToDoListDelegate: class {
    
    func Update(task: ToDoItem, index: Int)
}

class ToDoListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var toDoItems: [ToDoItem] = [ToDoItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        tableView.delegate = self
        
        tableView.dataSource = self
        
        tableView.tableFooterView = UIView()
        
        title = "To Do List"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editTapped))
        
        
        let testItem = ToDoItem(name: "test", details: "test details", completionDate: Date())
        
        toDoItems.append(testItem)
        
        let testItem2 = ToDoItem(name: "test 2", details: "test details 2", completionDate: Date())
        
        toDoItems.append(testItem2)
        
          NotificationCenter.default.addObserver(self, selector: #selector(addNewTask(notification:)), name: NSNotification.Name.init("com.todolistapp.addtask"), object: nil)
       
    }
    
    deinit {

          NotificationCenter.default.removeObserver(self, name: NSNotification.Name.init("com.todolistapp.addtask"), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        tableView.setEditing(false, animated: false)
        
      
    }
    
    @objc func addNewTask(notification: NSNotification){
        
        if let toDoItem = notification.object as? ToDoItem {
            
            toDoItems.append(toDoItem)
            
            toDoItems.sort(by:{$0.completionDate > $1.completionDate})
            
            tableView.reloadData()
            
            
        }
    }
    
    @objc func addTapped() {
        
        performSegue(withIdentifier: "AddTaskSegue", sender: nil)
    }
    
    @objc func editTapped() {
        
        tableView.setEditing(!tableView.isEditing, animated: true)
        
        if tableView.isEditing {
            
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(editTapped))
            
        } else {
            
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editTapped))
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
      let selectedItem = toDoItems[indexPath.row]
        
      let toDoTuple = (indexPath.row, selectedItem)
        
      performSegue(withIdentifier: "TaskDetailsSegue", sender: toDoTuple)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let toDoItem = toDoItems[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell")!
        
        cell.textLabel?.text = toDoItem.name
        
        cell.detailTextLabel?.text = toDoItem.isComplete ? "Complete" : "Incomplete"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let contextItem = UIContextualAction(style: .destructive, title: "Delete") { (contextualAction, view, boolValue) in
            
            self.toDoItems.remove(at: indexPath.row)
            
            self.tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
            
        }
        
        let swipeActions = UISwipeActionsConfiguration(actions: [contextItem])

        return swipeActions
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "TaskDetailsSegue" {
            
            guard let destinationVC = segue.destination as? ToDoDetailsViewController else {return}
            
            guard let toDoTuple = sender as? (Int, ToDoItem) else {return}
            
            destinationVC.toDoIndex = toDoTuple.0
            
            destinationVC.toDoItem = toDoTuple.1
            
            destinationVC.delagate = self

        }
    }
    
}

extension ToDoListViewController: ToDoListDelegate {
    
    func Update(task: ToDoItem, index: Int) {
       
        toDoItems[index] = task
        
        tableView.reloadData()
        
    }

}
