////
////  PurposesViewModel.swift
////  Studian
////
////  Created by 이한규 on 2021/10/22.
////
//
//import UIKit
//
//class PurposesViewModel {
//    var purposes = [Purpose]()
//    var mainPurpose : Purpose?
//
//
//    init() {
//        self.purposes = loadPurposes()
//        if let purpose = purposes.randomElement(){
//
//            self.mainPurpose = purpose
//        }else {return}
//    }
//
//    func loadPurposes() -> [Purpose] {
//        var result = [Purpose]()
//        let samplePurpose = Purpose(image: UIImage(named: "2"), name: "연세대학교", oneSenetence: "독수리 같이 빛나자.")
//        result.append(samplePurpose)
//        return result
//    }
//
//}
//
//  PurposesViewModel.swift
//  Studian
//
//  Created by 이한규 on 2021/10/22.
//

import UIKit



class PurposesViewModel {
    var purposes : [Purpose] {
        return manager.purposes
    }
    var images : [UIImage] {//get only
        return manager.images
    }
    var countOfItem : Int {
        return purposes.count
    }
    
    var countIsValid: Bool {
        if countOfItem < 8 {return true}
        else if countOfItem >= 8 {return false}
        return false
    }
    
    
    var mainPurpose = Purpose(id: 1, name: "3", oneSenetence: "4")
    
    private let manager = PurposeManager.shared
    
    init() {
        //self.purposes = loadPurposes()
//        if let purpose = purposes.randomElement(){
//
//            self.mainPurpose = purpose
//        }else {return}
    }

    
    func loadPurposes() -> [Purpose] {
        var result = [Purpose]()
        let samplePurpose = Purpose(id: 1, name: "연세대학교", oneSenetence: "독수리 같이 빛나자.")
        result.append(samplePurpose)
        return result
    }
    
    
    func addPurpose(_ purpose: Purpose) {
        manager.addPurpose(purpose)
    }
    func addImage(_ image: UIImage){
        manager.addImage(image)
    }
    func addPurposeAndImage(purpose:Purpose,image:UIImage,completion:@escaping ()->Void){
        manager.addPurposeAndImage(purpose: purpose, image: image, completion: completion)
    }
    func deletePurpose(_ purpose: Purpose) {
        manager.deleteTodo(purpose)
    }
    func deleteImage(_ purpose: Purpose, index : Int){
        manager.deleteImage(purpose,index: index)
    }
    func loadPurposes2(completion:@escaping ()->Void){
        manager.retrieveTodo(completion: completion)
    }
    
    func updateImage(purpose:Purpose,image:UIImage,index: Int,completion:()->Void){
        manager.updateImage(purpose: purpose, image:image, index: index)
        completion()
    }
    func updatePurpose(_ purpose: Purpose) {
        manager.updatePurpose(purpose)
    }
    
    
    func purposeAndImage(id: Int) -> PurposeAndImage{
        return manager.purposeAndImage(id: id)
    }
    func refactorIndexes(){
        return manager.refactorIndexes()
    }

}

class PurposeManager {
    
    static let shared = PurposeManager()
    
    static var lastId: Int = 0
    
    var purposes: [Purpose] = []
    var images: [UIImage] = []
    //var images2 : [customImage] = []
    func createPurpose(name: String?, oneSentence: String?) -> Purpose {
        // [x] TODO: create로직 추가
        
        let nextId = PurposeManager.lastId + 1
        PurposeManager.lastId = nextId
        return Purpose(id: nextId, name: name!, oneSenetence: oneSentence!)
    }
    func purposeAndImage(id: Int) -> PurposeAndImage{
        return PurposeAndImage(purpose: purposes[id], image: images[id], index: id)
    }
    
    func refactorIndexes(){
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

        do {
            // Get the directory contents urls (including subfolders urls)
            let directoryContents = try FileManager.default.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil)
            print(directoryContents)
            let pngFiles = directoryContents.filter{ $0.pathExtension == "png" }
            print("png urls:",pngFiles)
            var CroppedpngFiles = pngFiles.map{ $0.deletingPathExtension().lastPathComponent
            }
            
                .filter{
                    if let firstCharacter = $0.first {
                        if firstCharacter.isNumber {
                            return true
                        }
                        else {
                            return false
                        }
                    }
                    return false
                }
            
            print("png list:", CroppedpngFiles)
            //숫자인데 string이면 sorted 하면 1다음에 2가아니라 11 이다 .ㅋㅋ
            var intArray = CroppedpngFiles.map{ str -> Int in
                if let int = Int(str) {
                    return int
                }
                else {return 0}
            }
            
            CroppedpngFiles = intArray.sorted{$0<$1}.map{String($0)}
            
            let fileManager = FileManager.default
            let directoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
//            let directoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("\(pngFile).png")
            
            for (i,pngFile) in CroppedpngFiles.enumerated() {
                var destinationURL = directoryURL.appendingPathComponent("\(pngFile).png")
                var rv = URLResourceValues()
                rv.name = "\(i).png"
                try? destinationURL.setResourceValues(rv)
            }

        } catch {
            print(error)
        }
//        var destinationURL = directoryURL.appendingPathComponent("qq.json")
//        var rv = URLResourceValues()
//        rv.name = "pp.json"
//        try? destinationURL.setResourceValues(rv)
    }
    
    
    
    func updatePurpose(_ purpose:Purpose){
        guard let index = purposes.firstIndex(of: purpose) else {return}
        //guard let name = purpose.name, let oneSentence = purpose.oneSenetence else {return}
        purposes[index].update(name: purpose.name, oneSentence: purpose.oneSenetence)
        savePurposes()
    }
    
    
    
    
    
    func updateImage(purpose:Purpose, image:UIImage,index: Int){
        //guard let index = purposes.firstIndex(of: purpose) else {return}
        images[index] = image
        ImageFileManager.saveImageInDocumentDirectory(image: image, fileName: "\(purpose.id).png")
        //guard let name = purpose.name, let oneSentence = purpose.oneSenetence else {return}
        //purposes[index].update(name: purpose.name, oneSentence: purpose.oneSenetence)
    }
    
    
    func addPurpose(_ purpose: Purpose) {
        // [x] TODO: add로직 추가
        purposes.append(purpose)
        savePurposes()
    }
    
    func addImage(_ image: UIImage){
        images.append(image)
        ImageFileManager.saveImageInDocumentDirectory(image: image, fileName: "\(PurposeManager.lastId).png")
    }
    
    func addPurposeAndImage(purpose:Purpose,image:UIImage,completion:@escaping ()->Void) {
        purposes.append(purpose)
        images.append(image)
        let workGroup = DispatchGroup()
        DispatchQueue.global().async(group:workGroup) {
            store(self.purposes, to: .documents, as: "purposes.json")
            print("저장1",self.purposes.count)
        }
        DispatchQueue.global().async(group:workGroup) {
            ImageFileManager.saveImageInDocumentDirectory(image: image, fileName: "\(PurposeManager.lastId).png")
            print("저장2",PurposeManager.lastId)
        }
        
        workGroup.notify(queue: .main){
            completion()
        }
        
    }
    
    
    
    
    
    func deleteTodo(_ purpose: Purpose) {
        // [x] TODO: delete 로직 추가
        purposes = purposes.filter { $0.id != purpose.id }
//        if let index = todos.firstIndex(of: todo) {
//            todos.remove(at: index)
//        }
        
        savePurposes()
        
    }
    func deleteImage(_ purpose:Purpose,index : Int){
        
        print("\(purpose.id).png")
        print(images.count)
        print("\(index)")
        images.remove(at: index)
        ImageFileManager.removeImageFromDocumentDirectory(fileName: "\(purpose.id).png")
        
    }
//    func saveTodo() {
//        Storage.store(purposes, to: .documents, as: "purposes.json")
//    }
//    func updateTodo(_ todo: Todo) {
//        // [x] TODO: updatee 로직 추가
//        guard let index = todos.firstIndex(of: todo) else { return }
//        todos[index].update(isDone: todo.isDone, detail: todo.detail, isToday: todo.isToday)
//        saveTodo()
//    }
    
    func savePurposes() {
        store(purposes, to: .documents, as: "purposes.json")
    }
    
    
    func retrieveTodo(completion:@escaping ()->Void) {//cell들에 할것
//        var images : [UIImage]?
        DispatchQueue.global().async {
            retrive(fileNavigation.purposes, from: .documents, as: [Purpose].self, completion: { [weak self] purposes in
                print("hi")
                self?.purposes = purposes
                print("hi",purposes.count)
                if purposes.count != 0{
                        purposes.forEach{
                            let image = ImageFileManager.loadImageFromDocumentDirectory(fileName: "\($0.id).png",completion: {_ in
                                print("hi")
                            }) ?? UIImage(systemName: "circle")!
                            self?.images.append(image)
                            print(self?.images.count)
                            print("몇개",self?.purposes.count)
                        }
                    
                    DispatchQueue.main.async {
                        completion()
                        let lastId = purposes.last?.id ?? 0
                        PurposeManager.lastId = lastId
                        print("lastid",PurposeManager.lastId)
                    }
                }
            })
        }
        
        
    }
}
