//
//  ToDoDetailsViewController.swift
//  ToDoList
//
//  Created by Sandu on 1/6/22.
//  Copyright © 2022 Sandu. All rights reserved.
//

import UIKit


class ToDoDetailsViewController: UIViewController {

    @IBOutlet weak var taskTitleLabel: UILabel!
    
    @IBOutlet weak var taskDetailsTextView: UITextView!

    @IBOutlet weak var taskCompletionButton: UIButton!
    
    @IBOutlet weak var taskCompletionDateLabel: UILabel!
    
    var toDoItem: ToDoItem!
    
    var toDoIndex: Int!
    
    var message = "Hello World"
    
    weak var delagate: ToDoListDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(message)
        
        taskTitleLabel.text = toDoItem.name
        
        taskDetailsTextView.text = toDoItem.details
        
        if toDoItem.isComplete {
            
            disableButton()
        }

        let formater = DateFormatter()
        
        formater.dateFormat = "MMM dd, yyyy hh:mm"
        
        let taskDate = formater.string(from: toDoItem.completionDate)
        
        taskCompletionDateLabel.text = taskDate
        
    }
    
    
    func disableButton() {
        
        taskCompletionButton.backgroundColor = UIColor.gray
        
        taskCompletionButton.isEnabled = false
        
        
    }
    
    @IBAction func CompleteButtonDidTouch(_ sender: Any) {
        
        toDoItem.isComplete = true
        
        delagate?.Update(task: toDoItem, index: toDoIndex)
        
        disableButton()
        
    }
    
 

}
