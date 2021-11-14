//
//  EditTextViewController.swift
//  Studian
//
//  Created by 이한규 on 2021/10/29.
//

import Foundation
import UIKit
import Combine

protocol EditTextViewControllerDelegate: class {
    func change(text:String?)
}

class EditTextViewController : UIViewController, UITextViewDelegate{
    private let textView = CustomTextView()
    weak var viewModel :HeaderModel?
    var TextViewText: String?
    private var subscribers = Set<AnyCancellable>()
    weak var delegate : EditTextViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        textView.delegate = self
        //tapGesture()
        //observeForm()
        textViewDone()
    }
    func textViewDone(){
        self.textView.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
         self.view.endEditing(true)
   }//텍스트뷰말고 다른곳 클릭시 키보드내려감.
    @objc func tapDone(sender: Any) {
            self.view.endEditing(true)
        }  
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
                    textView.resignFirstResponder()
                    return false
                }
                return true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        delegate?.change(text: textView.text)
    }
    
    func updateUI(){
        view.backgroundColor = .black
        view.addSubview(textView)
//        textView.text = TextViewText ?? ""
        textView.text = viewModel?.textViewText ?? ""
        textView.anchor(top:view.safeAreaLayoutGuide.topAnchor,left: view.safeAreaLayoutGuide.leftAnchor,bottom: view.safeAreaLayoutGuide.bottomAnchor,right: view.safeAreaLayoutGuide.rightAnchor,paddingTop: 32,paddingLeft: 16,paddingBottom: 250,paddingRight: 16)
        textView.isEditable = true
        
        
    }
//    func observeForm(){////여기에 하면 한 문자쓸때마다
//        NotificationCenter.default.publisher(for: UITextView.textDidChangeNotification, object: textView).compactMap{
//            ($0.object as? UITextView)?.text
//        }.sink{ (text) in
//            //self.TextViewText = text
//            self.delegate?.change(text: text)
//            //print("\(text)")
//        }.store(in: &subscribers)
//    }
    
    
    
    
    
}

