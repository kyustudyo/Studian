//
//  CustomeTextField.swift
//  ChatApp
//
//  Created by 이한규 on 2021/09/10.
//

import UIKit

class CustomTextField: UITextField {
    init(placeholder:String) {
        super.init(frame: .zero)
        self.addDoneButtonOnKeyboard()
        borderStyle = .none
        font = UIFont.systemFont(ofSize: 16)
        textColor = .white
        keyboardAppearance = .default
        attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [.foregroundColor : UIColor.white])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
