//
//  Today.swift
//  Studian
//
//  Created by 이한규 on 2021/11/06.
//

import Foundation
import UIKit
struct Today : Equatable, Codable {
    var id: Int
    var imageData : Data
    var todos : [Todo]
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
    
    mutating func add(todo:Todo) {
        todos.append(todo)
    }
    
    mutating func remove(todo:Todo) {
        todos.removeAll{$0.id == todo.id}
    }
    
    mutating func editImage(image:UIImage){
        self.imageData = image.pngData() ?? Data()
    }
    
}
struct Todo : Codable {
    
    var id : Int
    var todoName : String
    var todoDetail : String
    var doOrNot : Bool
    
    mutating func update(todoName:String,todoDetail:String,doOrNot:Bool){
        self.todoName = todoName
        self.todoDetail = todoDetail
        self.doOrNot = doOrNot
    }
    
    mutating func click(doOrNot:Bool){
        self.doOrNot = doOrNot
    }
}
