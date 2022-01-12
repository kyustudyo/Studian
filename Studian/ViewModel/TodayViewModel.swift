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
    
    var countOfItems : Int {
        return manager.todays.count
    }
    
    var countIsValid: Bool {
        manager.todays.count < 20 ? true : false
    }
    
    var images : [UIImage] {
        return manager.images
    }
    
    func loadPurposes(completion: @escaping ()->Void){//escaping안하면안된다.
        manager.retrieveTodo(completion: completion)
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
    func getIndexesOfDoSelect(today:Today)->[IndexPath]{
        manager.getIndexesOfDoSelect(today: today)
    }
    
    func createTableCell (today:Today) {
        manager.createTableCell(today: today)
    }
}

class TodayManager {
    
    private init() { }
    static let shared = TodayManager()
    static var lastId : Int = 0
    static var tableCellLastIdDict = Dictionary<Int,Int>()
    
    var todays: [Today] = []
    var images: [UIImage] = []
    
    
    func retrieveTodo(completion: @escaping ()->Void) {//cell들에 할것
        DispatchQueue.global().async {
            retrive(fileNavigation.todays.fileName,
                    from: .documents,
                    as: [Today].self,
                    completion: { [weak self] todays in
                self?.todays = todays
                print("DEBUG: count of todays: ",todays.count)// 곱하기 2 되어서 나온다.
                if todays.count != 0{
                    todays.forEach{
                            let image = UIImage(data: $0.imageData) ?? UIImage()
                        self?.images.append(image)
                    }
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
                    LastIdDict.updateValue(lastId, forKey: id)
                }
                TodayManager.lastId = lastId
                TodayManager.tableCellLastIdDict = LastIdDict
                print("lastId",lastId,"lastIdDict:",LastIdDict,LastIdDict.count)
                DispatchQueue.main.async {
                    completion()
                }
            })
        }
    }
    func deleteImage(index:Int){
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
       
    }
    func updateToday (today: Today, todo: Todo){//사실상 추가
        guard let index = todays.firstIndex(of: today) else {return}
        todays[index].add(todo: todo)
        todays[index].add(todo: Todo(id: todo.id + 1, todoName: "", todoDetail: "",doOrNot: false))//dummy.
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
        guard let todayIndex = todays.firstIndex(of: today),
              let todoIndex = todays[todayIndex].todos.firstIndex(where: { component in
            todo.id == component.id}) else {return}
        
        
        todays[todayIndex].todos[todoIndex].configure(todoName: todo.todoName, todoDetail: todo.todoDetail,doOrNot: todo.doOrNot)
        print("변경후:",todays[todayIndex].todos[todoIndex])
    }
    
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
            store(self.todays, to: .documents, as: fileNavigation.todays)
        }
        workGroup.notify(queue: .main) {
            completion()
        }

    }
    func getIndex(_ today : Today) -> Int {
         return todays.firstIndex(of: today) ?? 0
    }
    
    func getTodo(today:Today,index:Int)->Todo{
        let todos = todays[getIndex(today)].todos
        let todo = todos[index]
        return todo
    }
    
    func deleteToday(_ today : Today) {
        todays = todays.filter { $0.id != today.id && $0.id != today.id + 1 }
    }
    
    func getIndexesOfDoSelect(today:Today)->[IndexPath]{
        var selectedRows = [IndexPath]()
        for (index,todo) in today.todos.enumerated() {
            if todo.doOrNot {
                let indexPath = IndexPath(indexes: [0,index])
                if !selectedRows.contains(indexPath){
                    selectedRows.append(indexPath)
                }
            }
        }
        return selectedRows
    }
}
