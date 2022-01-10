//
//  TodayHeaderViewModel.swift
//  Studian
//
//  Created by 이한규 on 2021/10/29.
//

import Foundation
import UIKit

protocol typeInjection: Encodable {
    
}

struct HeaderModel: Decodable, Encodable, typeInjection{
    var textViewText : String?
    var textFieldText1: String?
    var textFieldText2: String?
    var headerImage : Data?
    
    init(textViewText:String?,textFieldText1:String?,textFieldText2:String?,headerImage:UIImage?){
        self.textViewText = textViewText
        self.textFieldText1 = textFieldText1
        self.textFieldText2 = textFieldText2
        self.headerImage = headerImage?.pngData()
    }
    
}
