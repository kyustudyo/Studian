//
//  TodayHeaderViewModel.swift
//  Studian
//
//  Created by 이한규 on 2021/10/29.
//

import Foundation
import UIKit


struct HeaderModel: Decodable, Encodable{
    
    var textViewText : String?
    var textFieldText1: String?
    var textFieldText2: String?
    var headerImage : Data?
    
    init(textViewText:String? = nil,textFieldText1:String? = nil,textFieldText2:String? = nil,headerImage:UIImage? = nil){
        self.textViewText = textViewText
        self.textFieldText1 = textFieldText1
        self.textFieldText2 = textFieldText2
        self.headerImage = headerImage?.pngData()
    }
    
}
