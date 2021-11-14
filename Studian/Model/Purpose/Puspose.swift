//
//  Puspose.swift
//  Studian
//
//  Created by 이한규 on 2021/10/22.
//

import Foundation
import UIKit

struct Purpose : Equatable, Codable{
    var id : Int
    //let image: UIImage?
    var name: String
    var oneSenetence: String
    mutating func update(name:String,oneSentence:String){
        self.name = name
        self.oneSenetence = oneSentence
    }
//    init(id:Int,name:String,image:UIImage,oneSentence:String){
//        self.id = id
//        self.name = name
//        self.oneSenetence = oneSentence
//        self.image = UIImage(named: "1")
//    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
}

struct PurposeAndImage {
//    let id : Int?
    var purpose : Purpose?
    var image : UIImage?
    var index : Int?
}
