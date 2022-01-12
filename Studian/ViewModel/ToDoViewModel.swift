//
//  toDoViewModel.swift
//  Studian
//
//  Created by 이한규 on 2022/01/11.
//

import Foundation
import UIKit

class ToDoViewModel {
    enum textKinds {
        case toDoName
        case toDoDetail
        
    }
    var toDo : Todo
    
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
        print("textKinds:",textKinds,
              "내가쓴것:",text,
              "todo.name:",toDo.todoName,
              "todo.detail:",toDo.todoDetail)
        return toDo
    }
}
