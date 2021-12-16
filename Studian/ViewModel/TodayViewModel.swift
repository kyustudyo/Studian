//
//  TodayViewModel.swift
//  Studian
//
//  Created by 이한규 on 2021/11/06.
//

import Foundation
import UIKit
class TodayViewModel {
    private let manager = TodayManager.shared
    var todays : [Today] {
        return manager.todays
    }
    var images : [UIImage] {
        return manager.images
    }
    func loadPurposes2(completion:@escaping ()->Void){//escaping안하면안된다.
        manager.retrieveTodo(completion2: completion)
    }
    func addToday(_ today: Today){
        manager.addToday(today)
    }
    func deleteToday(_ today:Today){
        manager.deleteToday(today)
    }
    func deleteImage(index: Int){
        manager.deleteImage(index:index)
    }
    func deleteTodo(today:Today, todo:Todo){
        manager.deleteTodo(today:today, todo:todo)
    }
    func updateTodate(today: Today,todo: Todo){
        manager.updateToday(today: today, todo: todo)
    }
    func updateTodo(today: Today, todo : Todo){
        manager.updateTodo(today: today, todo: todo)
    }
    func getNumberOfTodos(today:Today) -> Int{
        return manager.getNumberOfTodos(today: today)
    }
    func getIndex(today:Today) -> Int {
        return manager.getIndex(today)
    }
    
    
    func getTodo(today:Today,index:Int)->Todo {
        manager.getTodo(today: today, index: index)
    }
    
    
    func saveTodays(completion:@escaping ()->Void){
        manager.saveTodays(completion: completion)
        
    }
    func editToday(image:UIImage, index: Int,completion:@escaping ()->Void){
        manager.editToday(image: image, index: index,completion: completion)
    }
//    func updateTodo(_ today:Today){
//        guard let index = todays.firstIndex(of: today) else {retrun}
//        todays[index]
//    }
    
}

class TodayManager {
    static let shared = TodayManager()
    static var lastId : Int = 0
    static var yPosition : Int = 0
    static var tableCellLastIdDict = Dictionary<Int,Int>()
    static var todayIdAndyPosition = [0,0]
    
    var todays: [Today] = []
    var images: [UIImage] = []
     
    func retrieveTodo(completion2: @escaping ()->Void) {//cell들에 할것
        //var images : [UIImage]?
        
        DispatchQueue.global().async {
            retrive("todays.json", from: .documents, as: [Today].self,completion: { [weak self] todays in
                
                self?.todays = todays
                print("몇개@@",todays.count)// 곱하기 2 되어서 나온다.
                print("몇개",todays)
                if todays.count != 0{
                    todays.forEach{
                        
        //                guard let image = ImageFileManager.loadImageFromDocumentDirectory(fileName: "\($0.id).png") else {return}
                        print($0.imageData.description)
                        //if $0.imageData.description != "30242712 bytes" {
                            let image = UIImage(data: $0.imageData) ?? UIImage()
                        self?.images.append(image)
                        //}
                        
        //                images.append(image)
                    }
                    
                    print("총몇개 d:\(self?.images.count)")
                    
                }
                
                let lastId = todays.last?.id ?? 0
                var LastIdDict = Dictionary<Int,Int>()
                var todoIds = Array<Int>()
                for i in 0..<todays.count {
                    let id = todays[i].id
                    
                    for todo in todays[i].todos{
                        todoIds.append(todo.id)
                    }
                    let lastId = todoIds.max() ?? 0
                    let numberOfTodo = todays[i].todos.count
                    
        //            LastIdDict.updateValue(numberOfTodo, forKey: id)
                    LastIdDict.updateValue(lastId, forKey: id)
                }
                TodayManager.lastId = lastId
                TodayManager.tableCellLastIdDict = LastIdDict
                
                DispatchQueue.main.async {
                    completion2()
                }
            })
        }
        
        
        
    }
    func deleteImage(index:Int){
        print("delete index ", index)
        print("delete index2 ",images.count)
        print("delete index3 ",index/2)
        images.remove(at: (index))
        images.remove(at: (index))
    }
    
    func createIndexAndData(image: UIImage) -> Today {
    let nextId = TodayManager.lastId + 2 //인덱스 하나 추가해야하므로
        TodayManager.lastId = nextId
        
        
        
    let imageData = image.pngData()!
    return Today(id: nextId, imageData: imageData, todos: [])
        
    }
    
    
    
    
    func getNumberOfTodos(today:Today) -> Int {
        let today = todays.first {$0.id == today.id}
        return today?.todos.count ?? 0
    }
    
    
    func createTableCell (today:Today) {
        let nextId = (TodayManager.tableCellLastIdDict[today.id] ?? 0) + 2
        //현재 껐다켰을 때 이전이 12,13 까지 만들어놨다면 다시 들어오면 15,16 이렇게 만드는데
        //딱히 문제없어서 그냥 두었다. 나중에 문제 발생시 수정.
        TodayManager.tableCellLastIdDict[today.id] = nextId
        print("nextId",nextId)
        //return today
    }
    func updateToday (today: Today, todo: Todo){//사실상 추가
        guard let index = todays.firstIndex(of: today) else {return}
        todays[index].add(todo: todo)
        todays[index].add(todo: Todo(id: todo.id + 1, todoName: "", todoDetail: "",doOrNot: false))
        //saveTodays()
        print("update:\(TodayManager.shared.todays)")
    }
    func deleteTodo(today:Today,todo:Todo){
        guard let index = todays.firstIndex(of: today) else {return}
        todays[index].remove(todo: todo)
        print(todays)
        todays[index].remove(todo: Todo(id: todo.id+1, todoName: "", todoDetail: "",doOrNot: false))
        print(todays)
        //saveTodays()
        //print("update:\(TodayManager.shared.todays)")
    }
    func updateTodo(today:Today,todo: Todo){
        guard let todayIndex = todays.firstIndex(of: today) else {return}
        guard let todoIndex = todays[todayIndex].todos.firstIndex(where: { to in
            todo.id == to.id
        }) else {return}
        
        todays[todayIndex].todos[todoIndex].update(todoName: todo.todoName, todoDetail: todo.todoDetail,doOrNot: todo.doOrNot)
        
            //saveTodays()
        
        
    }
//
//    func createTableCell(today:Today)->Today{
//        let nextId = TodayManager.tableCellLastIdArray
//    }
    
    func addToday(_ today: Today) {
        todays.append(today)
        todays.append(Today(id: today.id + 1, imageData: Data(),todos: today.todos))
        guard let image = UIImage(data: today.imageData) else {return}
        images.append(image)
        images.append(UIImage(systemName: "circle")!)
        
        //saveTodays()//한꺼번에 저장하자 여기서 하지말고.
        
        
        //saveImages()
    }
    func editToday(image:UIImage, index: Int,completion:@escaping ()->Void) {
        let workGroup = DispatchGroup()
        DispatchQueue.global().async(group:workGroup) { [weak self] in
            let originalIndex = index
            //let halfIndex = index / 2
            self?.images[originalIndex] = image
            //updatepurpose참고해서 다시.
            self?.todays[originalIndex].editImage(image: image)
        }
        workGroup.notify(queue: .main) {
            completion()
        }
        
        
    }
    
    
    func saveTodays(completion:@escaping ()->Void) {
        let workGroup = DispatchGroup()
        DispatchQueue.global().async(group: workGroup) {
            store(self.todays, to: .documents, as: "todays.json")
        }
        workGroup.notify(queue: .main) {
            completion()
        }
        
        
    }
    func getIndex(_ today : Today) -> Int {
         return todays.firstIndex(of: today) ?? 0
    }
    
    func getTodo(today:Today,index:Int)->Todo{
        let todos = todays[getIndex(today) ?? 0].todos
        let todo = todos[index]
        return todo
    }
    
    func deleteToday(_ today : Today) {
        // [x] TODO: delete 로직 추가
        todays = todays.filter { $0.id != today.id && $0.id != today.id + 1 }
//        images = images.filter{ UIImage(data: today.imageData) != $0 }
        //두개를 지우기위해.
//        if let index = todos.firstIndex(of: todo) {
//            todos.remove(at: index)
//        }
        
        //saveTodays()
        
    }
    
//    func saveImages() {
//            ImageFileManager.saveImageInDocumentDirectory(image: <#T##UIImage#>, fileName: <#T##String#>)
//    }
    
}
