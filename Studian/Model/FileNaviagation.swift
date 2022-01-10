//
//  FileNaviagation.swift
//  Studian
//
//  Created by 이한규 on 2022/01/08.
//

import Foundation
import UIKit

protocol ConfigurableFile {
    associatedtype dummyType
    var fileName : String { get }
    var path : String { get }
    var dummy: dummyType { get }
    var type: fileNavigation { get }
}

enum fileNavigation  {
    case todays
    case purposes
    case header
    
    
    var fileName : String {
        switch self {
        case .header: return "headerModel.txt"
        case .purposes: return "purposes.json"
        case .todays: return "todays.json"
        
        }
    }
    var imageName: String {
        switch self {
        case .header: return "PurposePicture.png"
        case .purposes: return "0.png"
        default: return ""
        }
    }
    var image : UIImage {
        switch self {
        case .header : return UIImage(named: "woman") ?? UIImage(systemName: "circle")!
        case .purposes : return UIImage(named: "0") ?? UIImage(systemName: "circle")!
        default : return UIImage(systemName: "circle")!
        }
    }
    
    
    var path : String {
        let baseUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let path = baseUrl.appendingPathComponent(fileName).path
        return path
    }
    
}



struct headerFile: ConfigurableFile {
    
    typealias dummyType = HeaderModel
    
    var type : fileNavigation {
        fileNavigation.header
    }
    
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

struct purposesFile: ConfigurableFile {
    
    
    typealias dummyType = [Purpose]
    
    var type : fileNavigation {
        fileNavigation.purposes
    }
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
    var type : fileNavigation {
        fileNavigation.todays
    }
    var fileName: String {
        fileNavigation.todays.fileName
    }
    var path: String {
        fileNavigation.todays.path
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
    var type: fileNavigation
    var fileName: String
    var path: String
    var dummy: dummyType
    var encodedData : Data?
    init<T: ConfigurableFile>(_ configurableCell: T){
        self.fileName = configurableCell.fileName
        self.path = configurableCell.path
        self.dummy = configurableCell.dummy
        self.type = configurableCell.type
        
        switch configurableCell.dummy {
        case let dummy as HeaderModel:
            encodedData = getencodedData(from: dummy)
//            print(encodedData)
        case let dummy as [Purpose]:
            encodedData = getencodedData(from: dummy)
//            print(encodedData)
        case let dummy as [Today]:
            encodedData = getencodedData(from: dummy)
//            print(encodedData)
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

