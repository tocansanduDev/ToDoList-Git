//
//  ToDoItemModel.swift
//  ToDoList
//
//  Created by Sandu on 1/6/22.
//  Copyright © 2022 Sandu. All rights reserved.
//

import Foundation

struct ToDoItem {
    
    var name: String
    
    var details: String
    
    var completionDate: Date
    
    var startDate: Date
    
    var isComplete: Bool
    
    init(name: String, details: String, completionDate: Date) {
        
        self.name = name
        
        self.details = details
        
        self.completionDate = completionDate
        
        self.isComplete = false
        
        self.startDate = Date()
    }

}
