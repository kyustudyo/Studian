//
//  FileManager+Extension.swift
//  Studian
//
//  Created by 이한규 on 2021/11/10.
//

import Foundation
extension FileManager {
    func clearTmpDirectory() {//tmp file에 이미지 쌓이는것방지.
        do {
            let tmpDirURL = FileManager.default.temporaryDirectory
            let tmpDirectory = try contentsOfDirectory(atPath: tmpDirURL.path)
            print(tmpDirectory)
            try tmpDirectory.forEach { file in
                print(file)
                let fileUrl = tmpDirURL.appendingPathComponent(file)
                try removeItem(atPath: fileUrl.path)
            }
        } catch {
           //catch the error somehow
        }
    }
}
