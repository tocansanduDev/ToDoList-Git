//
//  AddTaskViewController.swift
//  ToDoList
//
//  Created by Sandu on 1/6/22.
//  Copyright © 2022 Sandu. All rights reserved.
//

import UIKit

class AddTaskViewController: UIViewController {

    
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    @IBOutlet weak var taskNameTextField: UITextField!
    
    @IBOutlet weak var taskDetailsTextView: UITextView!
    
    @IBOutlet weak var taskCompletionDatePicker: UIDatePicker!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    lazy var touchView: UIView = {
        
       let _touchView = UIView()
        
        _touchView.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0)
        
        let touchViewTapped = UITapGestureRecognizer(target: self, action: #selector(dissmisKeyboard))
        
        _touchView.addGestureRecognizer(touchViewTapped)
        
        _touchView.isUserInteractionEnabled = true
        
        _touchView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        
        return _touchView
        
    }()
    
    let toolBarDone = UIToolbar.init()
    
    var activeTextField: UITextField?
    
    var activeTextView: UITextView?
    
    var keyboardNotification: NSNotification?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let navigationItem = UINavigationItem(title: "Add Task")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonDidTouch))
        
        navigationBar.items = [navigationItem]
        
        taskDetailsTextView.layer.borderColor = UIColor.lightGray.cgColor
        
        taskDetailsTextView.layer.borderWidth = CGFloat(1)
        
        taskDetailsTextView.layer.cornerRadius = CGFloat(3)
        
        toolBarDone.sizeToFit()
        
        toolBarDone.barTintColor = UIColor.red
        
        //toolBarDone.isTranslucent = false
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        
        let barBtnDone = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonTapped))
        
        barBtnDone.setTitleTextAttributes([NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 17), NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        
        toolBarDone.items = [flexSpace, barBtnDone, flexSpace]
        
        taskNameTextField.inputAccessoryView = toolBarDone
        
        taskDetailsTextView.inputAccessoryView = toolBarDone
        
        taskNameTextField.delegate = self
        
        taskDetailsTextView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        registerForKeyboardNotification()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        deregisterFromKeyboardNotification()
    }
    
    
    @IBAction func AddTaskDidTouch(_ sender: Any) {
        
        guard let taskName = taskNameTextField.text, !taskName.isEmpty else {
            
           reportError(title: "Invalid Task Name", message: "Task name is required")
            return
            
        }
        
//        if taskName.count > 50 {
//
//            //report error
//
//            return
//        }
//
//        guard let _ = Int(taskName) else {
//
//            return
//        }
//
        if taskDetailsTextView.text.isEmpty {
            
            
            reportError(title: "Invalid Task Details", message: "Task details are required")
            
            
            return
        }
        
        let completionDate: Date = taskCompletionDatePicker.date
        
        if completionDate < Date() {
            
            reportError(title: "Invalid Date", message: "Date must be in the future")
            
            
            return
        }
        
        let taskDetails: String = taskDetailsTextView.text
        
        let toDoItem = ToDoItem(name: taskName, details: taskDetails, completionDate: completionDate)
        
        NotificationCenter.default.post(name: NSNotification.Name.init("com.todolistapp.addtask"), object: toDoItem)
        
        dismiss(animated: true, completion: nil)
        
        
    }
    
    func reportError(title: String, message: String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default) { (action) in
            
            alert.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
    func registerForKeyboardNotification() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(notification:)), name: UIWindow.keyboardDidShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasHidden(notification:)), name: UIWindow.keyboardWillHideNotification, object: nil)
    }
    
    func deregisterFromKeyboardNotification() {
        
        NotificationCenter.default.removeObserver(self, name: UIWindow.keyboardDidShowNotification, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: UIWindow.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWasShown(notification: NSNotification){
         
        view.addSubview(touchView)
        
        self.keyboardNotification = notification
        
        let info: NSDictionary = notification.userInfo! as NSDictionary
        
        let keyboardSize = (info[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        
        let contentInsets: UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: (keyboardSize!.height + toolBarDone.frame.size.height + 10.0), right: 0.0)
        
        self.scrollView.contentInset = contentInsets
        
        self.scrollView.scrollIndicatorInsets = contentInsets
        
        var aRect: CGRect = UIScreen.main.bounds
        
        aRect.size.height -= keyboardSize!.height
        
        if activeTextField != nil {
            
            if (!aRect.contains(activeTextField!.frame.origin)) {
                
                self.scrollView.scrollRectToVisible(activeTextField!.frame, animated: true)
            }
        } else if activeTextView != nil {
            
            let textViewPoint: CGPoint = CGPoint(x: activeTextView!.frame.origin.x, y: activeTextView!.frame.size.height)
            
            if aRect.contains(textViewPoint) {
                
                self.scrollView.scrollRectToVisible(activeTextView!.frame, animated: true)
            }
        }
        
    }
    
    @objc func keyboardWasHidden(notification: NSNotification){
           
        touchView.removeFromSuperview()
        
        let contentInsets: UIEdgeInsets = UIEdgeInsets.zero
        
        self.scrollView.contentInset = contentInsets
        
        self.scrollView.scrollIndicatorInsets = contentInsets
        
        self.view.endEditing(true)
    }
    
    @objc func dissmisKeyboard(){
        
         view.endEditing(true)
        
    }
    
    @objc func doneButtonTapped() {
        
        view.endEditing(true)
    }
    
    @objc func cancelButtonDidTouch() {
        
        dismiss(animated: true, completion: nil)
        
    }


}

extension AddTaskViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        activeTextField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        activeTextField = nil
    }
    
}


extension AddTaskViewController: UITextViewDelegate {

    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        activeTextView = textView
        
        guard let notification = self.keyboardNotification else {return}
        
        let info: NSDictionary = notification.userInfo! as NSDictionary

        let keyboardSize = (info[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size

        let contentInsets: UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: (keyboardSize!.height + toolBarDone.frame.size.height + 10.0), right: 0.0)

        self.scrollView.contentInset = contentInsets

        self.scrollView.scrollIndicatorInsets = contentInsets

        var aRect: CGRect = UIScreen.main.bounds

        aRect.size.height -= keyboardSize!.height


        let textViewPoint: CGPoint = CGPoint(x: textView.frame.origin.x, y: textView.frame.size.height + textView.frame.size.height)

        if aRect.contains(textViewPoint) {

            self.scrollView.scrollRectToVisible(textView.frame, animated: true)
        }
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
       activeTextView = nil
    }
    
    
    
}
