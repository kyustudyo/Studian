//
//  toDoViewModel.swift
//  Studian
//
//  Created by 이한규 on 2022/01/11.
//

import Foundation
import UIKit

struct ToDoViewModel {
    enum textKinds {
        case toDoName
        case toDoDetail
        
    }
    let toDo : Todo
    
    init(toDo: Todo) {
        self.toDo = toDo
    }
    var toDoName: String {
        return toDo.todoName
    }
    var toDoDetail: String {
        return toDo.todoDetail
    }
    var doOrNot: Bool {
        return toDo.doOrNot
    }
    var doOrNotColor : UIColor {
        toDo.doOrNot == true ? .green : .red
    }
    
    func configureToDo(toDo:Todo, text:String, textKinds:textKinds)->Todo {
        var toDo = toDo
        switch textKinds {
        case .toDoName:
            toDo.configure(todoName: text,
                           todoDetail: toDo.todoDetail,
                           doOrNot: toDo.doOrNot)
        case .toDoDetail:
            toDo.configure(todoName: toDo.todoName,
                           todoDetail: text,
                           doOrNot: toDo.doOrNot)
        }
        return toDo
    }
}
