//
//  CustomTextView.swift
//  Studian
//
//  Created by 이한규 on 2021/10/29.
//

import Foundation
import UIKit
class CustomTextView: UITextView {
    var textChangeClosure: (String)->() = {_ in}
    
    func bind(callback: @escaping (String)->()){
        self.textChangeClosure = callback
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        
        
        backgroundColor = .white
        textColor = .black
        layer.masksToBounds = true
        layer.cornerRadius =  10.0
        layer.borderWidth = 1 // Set the border color to black.
        layer.borderColor = UIColor.white.cgColor // Set the font.
        font = UIFont.systemFont(ofSize: 20.0) // Set font color.
        //textColor = UIColor.black // Set left justified.
        textAlignment = NSTextAlignment.left // Automatically detect
//        links, dates, etc. and convert them to links.
        dataDetectorTypes = UIDataDetectorTypes.all // Set shadow darkness.
        layer.shadowOpacity = 0.5 // Make text uneditable.
        isEditable = false
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
