//
//  FileManager.swift
//  Studian
//
//  Created by 이한규 on 2021/10/26.
//

import Foundation
import UIKit

typealias saveImageFuncType = (UIImage, String) -> URL?
let saveImage : saveImageFuncType = { (uiimage, string) in
    return ImageFileManager.saveImageInDocumentDirectory(image: uiimage, fileName: string)
}

//protocol MyEncodable: Encodable {
//    func toJSONData() -> Data?
//}
//
//extension MyEncodable {
//    func toJSONData() -> Data?{ try? JSONEncoder().encode(self) }
//}
//class TestClass2: NSObject, MyEncodable {
//    var x = 1
//    var y = 2
//}
//
//func decodeStickers<T : Decodable>(from data : Data) throws -> T
//{
//    return try JSONDecoder().decode(T.self, from: data)
//}

func firstTime(completion: @escaping ()->Void){
    
    let fileManager = FileManager.default
        let baseUrl = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    let headerFile = fileConfigurable(headerFile())
    let purposeFile = fileConfigurable(purposesFile())
    let todayFile = fileConfigurable(todaysFile())
    let jsonFiles = [headerFile, purposeFile, todayFile]

    let WorkGroup = DispatchGroup()
    
    for file in jsonFiles {
        if !fileManager.fileExists(atPath: file.path){
            //존재하지않는 것이 있을때.
            DispatchQueue.global().async(group:WorkGroup){
                let data = file.encodedData
                print(data,file.path)
                fileManager.createFile(atPath: file.path, contents: data, attributes: nil)
            }
            DispatchQueue.global().async(group:WorkGroup) {
                if file.type == .header ||
                    file.type == .purposes {
                    saveImage(file.type.image,
                              file.type.imageName)
                }
            }
        }
    }
    WorkGroup.notify(queue: .main){
        completion()
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

func retrive<T: Decodable>(_ fileName: String, from directory: Directory, as type: T.Type, completion: @escaping (T)->Void) {
    
//    DispatchQueue.global().async {
    let url = directory.url.appendingPathComponent(fileName, isDirectory: false)
        if !FileManager.default.fileExists(atPath: url.path){
        }
    
        guard let data = FileManager.default.contents(atPath: url.path) else {
            return }
        let decoder = JSONDecoder()
        do {
            let model = try decoder.decode(type, from: data)
                completion(model)
        } catch let error {
            print("---> Failed to decode msg: \(error.localizedDescription)")
//            return nil
        }
//    }
        
    
    
    
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




