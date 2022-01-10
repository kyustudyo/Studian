//
//  FileNaviagation.swift
//  Studian
//
//  Created by 이한규 on 2022/01/08.
//

import Foundation
import UIKit



//enum fileNavigation  {
//
//    case todays
//    case purposes
//    case header
//
//    func getFile<T:Encodable>() -> fileInfo<T> {
//        switch self{
//        case .header :
//            return fileInfo(fileName: fileName,
//                            path: getPath(fileName),
//                            dummy: headerDummy as? T)
//        case .purposes :
//            return fileInfo(fileName: fileName,
//                            path: getPath(fileName),
//                            dummy: purposeDummy as? T)
//        case .todays :
//            return fileInfo(fileName: fileName,
//                            path: getPath(fileName),
//                            dummy: todayDummy as? T)
//        }
//    }
//
//    var fileName : String {
//        switch self {
//        case .header: return "headerModel.txt"
//        case .purposes: return "purposes.json"
//        case .todays: return "todays.json"
//        }
//    }
//
//    var headerDummy : HeaderModel {
//        HeaderModel(textViewText: "Until now but..", textFieldText1: "Engineer", textFieldText2: "For that day...",headerImage: nil)
//    }
//    var purposeDummy : [Purpose] {
//        [Purpose(id: 0, name: "just do it", oneSenetence: "중요한건 방향!")]
//    }
//    var todayDummy : [Today] {
//        [Today(id: 0, imageData: (UIImage(named: "today") ?? UIImage(systemName: "circle")!).pngData() ?? Data(), todos: [
//            Todo(id: 0, todoName: "math homework", todoDetail: "page 1 ~ 30", doOrNot: true),
//            Todo(id: 1, todoName: "", todoDetail: "", doOrNot: false),
//            Todo(id: 2, todoName: "Test !", todoDetail: "At 3 pm", doOrNot: false),
//            Todo(id: 3, todoName: "", todoDetail: "", doOrNot: false),
//                          Todo(id: 4, todoName: "review", todoDetail: "30 minutes", doOrNot: true),
//                          Todo(id: 5, todoName: "", todoDetail: "", doOrNot: false)
//        ]),
//
//                          Today(id: 1, imageData: UIImage().pngData() ?? Data(), todos: [])
//                                ]
//    }
//    func getPath(_ fileName:String)->String {
//        let baseUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//        let path = baseUrl.appendingPathComponent(fileName).path
//        return path
//    }
//}






protocol ConfigurableFile {
    associatedtype dummyType
    var fileName : String { get }
    var path : String { get }
    var dummy: dummyType { get }
}



enum fileNavigation  {
    case todays
    case purposes
    case header
    case image
    var fileName : String {
        switch self {
        case .header: return "headerModel.txt"
        case .purposes: return "purposes.json"
        case .todays: return "todays.json"
        default : return "maybe images.."
        }
    }
    
    var imageFiles: [String:UIImage?] {
        ["0.png":UIImage(named: "0"),"PurposePicture.png":UIImage(named: "woman")]
        
    }
    var path : String {
        let baseUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let path = baseUrl.appendingPathComponent(fileName).path
        return path
    }
    
}



struct headerFile: ConfigurableFile {
    
    typealias dummyType = HeaderModel
    var fileName: String {
        fileNavigation.header.fileName
    }
    var path: String {
        fileNavigation.header.path
    }
    var dummy: dummyType {
        HeaderModel(textViewText: "Until now but..", textFieldText1: "Engineer", textFieldText2: "For that day...",headerImage: nil)
    }
    
}

//func get_comparable_value<T:Comparable>() -> T {
//  return 1 as! T
//}
struct purposesFile: ConfigurableFile {
    
    
    typealias dummyType = [Purpose]
    var fileName: String {
        fileNavigation.purposes.fileName
    }
    var path: String {
        fileNavigation.purposes.path
    }
    var dummy: dummyType {
        [Purpose(id: 0, name: "just do it", oneSenetence: "중요한건 방향!")]
    }
    
}
struct todaysFile: ConfigurableFile {
    
    typealias dummyType = [Today]
    var fileName: String {
        fileNavigation.todays.fileName
    }
    var path: String {
        fileNavigation.todays.fileName
    }
    var dummy: dummyType {
        [Today(id: 0, imageData: (UIImage(named: "today") ?? UIImage(systemName: "circle")!).pngData() ?? Data(), todos: [
            Todo(id: 0, todoName: "math homework", todoDetail: "page 1 ~ 30", doOrNot: true),
            Todo(id: 1, todoName: "", todoDetail: "", doOrNot: false),
            Todo(id: 2, todoName: "Test !", todoDetail: "At 3 pm", doOrNot: false),
            Todo(id: 3, todoName: "", todoDetail: "", doOrNot: false),
            Todo(id: 4, todoName: "review", todoDetail: "30 minutes", doOrNot: true),
            Todo(id: 5, todoName: "", todoDetail: "", doOrNot: false)
        ]),
         
         Today(id: 1, imageData: UIImage().pngData() ?? Data(), todos: [])
        ]
    }
   
}

class fileConfigurable : ConfigurableFile {
    
    enum dummyStyle {
        case header
        case purposes
        case todays
    }
    
    typealias dummyType = Any
    var fileName: String
    var path: String
    var dummy: dummyType
    var encodedData : Data?
    init<T: ConfigurableFile>(_ configurableCell: T){
        self.fileName = configurableCell.fileName
        self.path = configurableCell.path
        self.dummy = configurableCell.dummy
        switch configurableCell.dummy {
        case let dummy as HeaderModel:
            encodedData = getencodedData(from: dummy)
        case let dummy as [Purpose]:
            encodedData = getencodedData(from: dummy)
        case let dummy as [Today]:
            encodedData = getencodedData(from: dummy)
        default:
            break
        }

    }
    func getencodedData<T : Encodable>(from data : T) -> Data?
    {
        let encoder = JSONEncoder()
        var encodedData = Data()
        do {
            encodedData = try encoder.encode(data)
        } catch let error {
            print("---> Failed to store msg: \(error.localizedDescription)")
        }
        return encodedData
    }
}


//struct fileInfo<T:Encodable> :fileType {//T가 encodable이면 struct가 encodable.
//    let fileName: String
//    let path: String
//    let dummy: T?
//    init(fileName:String, path: String, dummy:T?){
//        self.fileName = fileName
//        self.path = path
//        self.dummy = dummy
//    }
//}
