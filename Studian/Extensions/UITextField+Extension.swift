//
//  UITextField+Extension.swift
//  Studian
//
//  Created by 이한규 on 2021/11/09.
//

import UIKit

//class ViewController: UIViewController {
//
//
//    @IBOutlet weak var textField: UITextField!
//
//    @IBOutlet weak var textView: UITextView!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // 완료 버튼을 붙이고자 하는 텍스트필드와 텍스트뷰에 addDoneButtonOnKeyboard() 메소드를 붙여주세요!
//        textField.addDoneButtonOnKeyboard()
//
//        //textView.addDoneButtonOnKeyboard()
//    }
//
//
//}

extension UITextField {
    func getCustomTextFieldSetting() {
        self.borderStyle = .none
        self.textColor = .black
        self.addDoneButtonOnKeyboard()
    }
    
    func addDoneButtonOnKeyboard() {
        
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        // MARK: 버튼의 이름과 색상을 바꾸고 싶다면 아래 title과 tintColor를 바꿔보세요!
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        done.tintColor = .gray
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
        
    }
    @objc func doneButtonAction() {
            self.resignFirstResponder()
        }
}
