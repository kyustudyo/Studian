//
//  FileManager.swift
//  Studian
//
//  Created by 이한규 on 2021/10/26.
//

import Foundation
import UIKit
struct Constants {
    static let sampleFileName = "sampleFile"
}
func MakeDummyPurpose(){
    
    let fileManager = FileManager.default
        let directoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    let destinationURL = directoryURL.appendingPathComponent("purposes.json")
    
    guard !fileManager.fileExists(atPath: destinationURL.path) else {
        print("이미존재")
        return
    }
//    let image = UIImage(named: "woman") ?? UIImage(systemName: "person")!
//    ImageFileManager.saveImageInDocumentDirectory(image: image, fileName: "-1.png")
    
    
    print("done")
//    let image = ImageFileManager.loadImageFromDocumentDirectory(fileName: "PurposePicture.png")
    if let img0 = UIImage(named: "0") {
        ImageFileManager.saveImageInDocumentDirectory(image: img0, fileName: "0.png")
    }
//    if let img1 = UIImage(named: "1") {
//        ImageFileManager.saveImageInDocumentDirectory(image: img1, fileName: "1.png")
//    }
//    let Dummy = [Purpose(id: 0, name: "", oneSenetence: ""),
//                 Purpose(id: 1, name: "", oneSenetence: "")]
//        let Dummy = HeaderModel(textViewText: "Until now but..", textFieldText1: "Engineer", textFieldText2: "For that day...",headerImage: nil)
        //l/et Dummy = Purpose(id: , name: <#T##String#>, oneSenetence: <#T##String#>)
//        let encoder = JSONEncoder()
        //let directoryURL = documentsURL.appendingPathComponent("Studian")
//        if !fileManager.fileExists(atPath: directoryURL.path) {
//                do {
//                    try fileManager.createDirectory(atPath: directoryURL.path, withIntermediateDirectories: false, attributes: nil)
//                } catch let e {
//                    print(e.localizedDescription)
//                }
//        } else {print("i already have the directory")}
        // 4. 저장할 파일 이름 (확장자 필수)
    
//        let helloPath = directoryURL.appendingPathComponent("purposes.json")
//
//    do {
//        let data = try encoder.encode(Dummy)
//        print(data)
////        if FileManager.default.fileExists(atPath: helloPath.path) {
////            return
////        }
//        FileManager.default.createFile(atPath: helloPath.path, contents: data, attributes: nil)
////        return Dummy
//
//    } catch let error {
//        print("---> Failed to store msg: \(error.localizedDescription)")
//    }
    
}

func firstTime(){
    
    let fileManager = FileManager.default
        let directoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    let destinationURL = directoryURL.appendingPathComponent("headerModel.txt")
    
    guard !fileManager.fileExists(atPath: destinationURL.path) else {
        print("이미존재")
        return
    }
    let image = UIImage(named: "woman") ?? UIImage(systemName: "person")!
    ImageFileManager.saveImageInDocumentDirectory(image: image, fileName: "PurposePicture.png")
    
    if let img0 = UIImage(named: "0") {
        ImageFileManager.saveImageInDocumentDirectory(image: img0, fileName: "0.png")
    }
    
    print("done")
//    let image = ImageFileManager.loadImageFromDocumentDirectory(fileName: "PurposePicture.png")
    
        let Dummy = HeaderModel(textViewText: "Until now but..", textFieldText1: "Engineer", textFieldText2: "For that day...",headerImage: nil)
    
    
        let PurposeDummy = [Purpose(id: 0, name: "just do it", oneSenetence: "중요한건 방향!")]
    var uiimage = UIImage()
    if let image = UIImage(named: "today"){
        uiimage = image
    } else { uiimage = UIImage(systemName: "circle")!}
    
    let todayDummy = [Today(id: 0, imageData: uiimage.pngData() ?? Data(), todos: [
        Todo(id: 0, todoName: "math homework", todoDetail: "page 1 ~ 30", doOrNot: true),
        Todo(id: 1, todoName: "", todoDetail: "", doOrNot: false),
        Todo(id: 2, todoName: "Test !", todoDetail: "At 3 pm", doOrNot: false),
        Todo(id: 3, todoName: "", todoDetail: "", doOrNot: false),
                      Todo(id: 4, todoName: "review", todoDetail: "30 minutes", doOrNot: true),
                      Todo(id: 5, todoName: "", todoDetail: "", doOrNot: false)
    ]),
        
                      Today(id: 1, imageData: UIImage().pngData() ?? Data(), todos: [])
                            ]
   
    
        let encoder = JSONEncoder()
        //let directoryURL = documentsURL.appendingPathComponent("Studian")
//        if !fileManager.fileExists(atPath: directoryURL.path) {
//                do {
//                    try fileManager.createDirectory(atPath: directoryURL.path, withIntermediateDirectories: false, attributes: nil)
//                } catch let e {
//                    print(e.localizedDescription)
//                }
//        } else {print("i already have the directory")}
        // 4. 저장할 파일 이름 (확장자 필수)
    
    let helloPath = directoryURL.appendingPathComponent("headerModel.txt")
    let purposePath = directoryURL.appendingPathComponent("purposes.json")
    let todayPath = directoryURL.appendingPathComponent("todays.json")
    do {
        let data = try encoder.encode(Dummy)
        print(data)
//        if FileManager.default.fileExists(atPath: helloPath.path) {
//            return
//        }
        FileManager.default.createFile(atPath: helloPath.path, contents: data, attributes: nil)
    } catch let error {
        print("---> Failed to store msg: \(error.localizedDescription)")
    }
    do {
        let data = try encoder.encode(PurposeDummy)
        print(data)
//        if FileManager.default.fileExists(atPath: helloPath.path) {
//            return
//        }
        FileManager.default.createFile(atPath: purposePath.path, contents: data, attributes: nil)
    } catch let error {
        print("---> Failed to store msg: \(error.localizedDescription)")
    }
    do {
        let data = try encoder.encode(todayDummy)
        print(data)
//        if FileManager.default.fileExists(atPath: helloPath.path) {
//            return
//        }
        FileManager.default.createFile(atPath: todayPath.path, contents: data, attributes: nil)
    } catch let error {
        print("---> Failed to store msg: \(error.localizedDescription)")
    }
    
}


func saveFile(text:String){// no caller
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let directoryURL = documentsURL.appendingPathComponent("Studian")
        if !fileManager.fileExists(atPath: directoryURL.path) {
                do {
                    try fileManager.createDirectory(atPath: directoryURL.path, withIntermediateDirectories: false, attributes: nil)
                } catch let e {
                    print(e.localizedDescription)
                }
        } else {print("i already have the directory")}
        // 4. 저장할 파일 이름 (확장자 필수)
        let helloPath = directoryURL.appendingPathComponent("new1.txt")
        
        do {
            // 4-1. 파일 생성
            try text.write(to: helloPath, atomically: false, encoding: .utf8)
        }catch let error as NSError {
            print("Error creating File : \(error.localizedDescription)")
        }
}
enum Directory {
    case documents
    case caches
    
    var url: URL {
        let path: FileManager.SearchPathDirectory
        switch self {
        case .documents:
            path = .documentDirectory
        case .caches:
            path = .cachesDirectory
        }
        return FileManager.default.urls(for: path, in: .userDomainMask).first!
    }
}


func store<T: Encodable>(_ obj: T, to directory: Directory, as fileName: String) {
    let url = directory.url.appendingPathComponent(fileName, isDirectory: false)
    //print("---> save to here: \(url)")
    let encoder = JSONEncoder()
    encoder.outputFormatting = .prettyPrinted
    
    do {
        let data = try encoder.encode(obj)
        if FileManager.default.fileExists(atPath: url.path) {
            try FileManager.default.removeItem(at: url)
        }
        FileManager.default.createFile(atPath: url.path, contents: data, attributes: nil)
        print("sd")
    } catch let error {
        print("---> Failed to store msg: \(error.localizedDescription)")
    }
}

func retrive<T: Decodable>(_ fileName: String, from directory: Directory, as type: T.Type,completion: @escaping (T)->Void) {
    
    DispatchQueue.global().async {
        var url = directory.url.appendingPathComponent(fileName, isDirectory: false)
        print("ssa",!FileManager.default.fileExists(atPath: url.path))
        if !FileManager.default.fileExists(atPath: url.path){
//            print("\(T.self),\([Purpose].self)")
//            print( T.self )
//            if type.self == [Purpose].self {
//                print("gogogo")
//                let purposes = MakeDummyPurpose()
////                guard purposes.self is [Purpose] else {return}
//                completion(purposes as! T)
//            }
            
            
            print("no way!")
//            if let img0 = UIImage(named: "0") {
//                ImageFileManager.saveImageInDocumentDirectory(image: img0, fileName: "0.png")
//            }
        }
        guard let data = FileManager.default.contents(atPath: url.path) else {
            print(",,,")
            return }
        print("data??",data)
        let decoder = JSONDecoder()
        
        do {
            let model = try decoder.decode(type, from: data)
//            print(model)
            //DispatchQueue.main.async {
                completion(model)
            //}
            
//            return model
        } catch let error {
            print("---> Failed to decode msg: \(error.localizedDescription)")
//            return nil
        }
    }
        
    
    
    
}

func remove(_ fileName: String, from directory: Directory) {
    let url = directory.url.appendingPathComponent(fileName, isDirectory: false)
    guard FileManager.default.fileExists(atPath: url.path) else { return }
    
    do {
        try FileManager.default.removeItem(at: url)
    } catch let error {
        print("---> Failed to remove msg: \(error.localizedDescription)")
    }
}

func clear(_ directory: Directory) {
    let url = directory.url
    do {
        let contents = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: [])
        for content in contents {
            try FileManager.default.removeItem(at: content)
        }
    } catch {
        print("---> Failed to clear directory ms: \(error.localizedDescription)")
    }
}


func loadFile(name: String) -> String? {
    let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
    let nsUserDomainMask = FileManager.SearchPathDomainMask.userDomainMask
    let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
    if let dirPath = paths.first {
        let file = URL(fileURLWithPath: dirPath).appendingPathComponent("Studian").appendingPathComponent(name)
        if let data = try? Data(contentsOf: file) {
            let dataString = String(data: data, encoding: .utf8)
            print(dataString)
            return dataString
        }
        return nil
    }
    return nil
}

func getDocumentsDirectory() -> URL {
    // find all possible documents directories for this user
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("Studian")

    // just send back the first one, which ought to be the only one
    return paths
}
