//
//  ImageFileManager.swift
//  Studian
//
//  Created by 이한규 on 2021/10/26.
//

import Foundation
import UIKit
class ImageFileManager {
  static let shared: ImageFileManager = ImageFileManager()
// Save Image
// name: ImageName
//  func saveImage(image: UIImage, name: String,
//                 onSuccess: @escaping ((Bool) -> Void)) {
//      print("시작.")
//      guard let data: Data
//    = image.jpegData(compressionQuality: 1)
//      ?? image.pngData() else { return }
//      let fileManager = FileManager.default
//      let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
//      let directoryURL = documentsURL.appendingPathComponent("Studian")
//      if !fileManager.fileExists(atPath: directoryURL.path) {
//              do {
//                  try fileManager.createDirectory(atPath: directoryURL.path, withIntermediateDirectories: false, attributes: nil)
//              } catch let e {
//                  print(e.localizedDescription)
//              }
//      }
//      do {
//          try data.write(to: directoryURL.appendingPathComponent(name))
//
//              onSuccess(true)
//      } catch let error as NSError {
//        print("error: \(error), \(error.userInfo)")
//        onSuccess(false)
//      }
//    
//  }
    
    public static func saveImageInDocumentDirectory(image: UIImage, fileName: String) -> URL? {
            
            let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!;
            let fileURL = documentsUrl.appendingPathComponent(fileName)
        if let imageData = image.pngData() {
                try? imageData.write(to: fileURL, options: .atomic)
            
                return fileURL
            }
        print("the end")
        
            return nil
        }
    
    public static func loadImageFromDocumentDirectory(fileName: String,completion: @escaping (UIImage)->Void) -> UIImage? {
            
            let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                print(documentsUrl)
        let fileURL = documentsUrl.appendingPathComponent(fileName)
            do {
                let imageData = try Data(contentsOf: fileURL)
                let image = UIImage(data: imageData) ?? UIImage(systemName: "circle")!
                completion(image)
                return UIImage(data: imageData)
            } catch {}
            return nil
        }
    
    public static func removeImageFromDocumentDirectory(fileName:String) {
        let fileManager = FileManager.default
        let tempFolderPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = tempFolderPath.appendingPathComponent(fileName)
        do {
            print("1")
            let filePaths = try fileManager.contentsOfDirectory(atPath: tempFolderPath.path)
            print("2")
            for filePath in filePaths {
                print("3")
                try fileManager.removeItem(atPath: fileURL.path)
                print("4")
                break
            }
        } catch {
            print("Could not clear temp folder: \(error)")
        }
    }
    
    
    
        
    
    
    
    
    
}
