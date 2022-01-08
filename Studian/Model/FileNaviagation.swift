//
//  FileNaviagation.swift
//  Studian
//
//  Created by 이한규 on 2022/01/08.
//

import Foundation
enum fileNavigation : String {
    case todays = "todays.json"
    case purposes = "purposes.json"
    case header = "headerModel.txt"
   
    var fileName : String {
        switch self {
        case .header: return "headerModel.txt"
        case .purposes: return "purposes.json"
        case .todays: return "todays.json"
        }
    }
    var path : String {
        switch self {
        case .header: return baseUrl.appendingPathComponent(fileNavigation.header.fileName).path
        case .purposes: return baseUrl.appendingPathComponent(fileNavigation.purposes.fileName).path
        case .todays: return baseUrl.appendingPathComponent(fileNavigation.todays.fileName).path
        }
    }
    
    var fileManager: FileManager { return FileManager.default }
    var baseUrl : URL {
        return fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
}
