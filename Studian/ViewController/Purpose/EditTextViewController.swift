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
    
    private let containerView : UIView = {
        let uiView = UIView()
        uiView.backgroundColor = .groupTableViewBackground
        return uiView
    }()
    private let completeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Complete!", for: .normal)
        button.layer.cornerRadius = 11
        
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        //button.layer.masksToBounds = true
        button.setHeight(height: 40)
        button.isEnabled = true
        button.addTarget(self, action: #selector(handleRegistration), for: .touchUpInside)
        return button
    }()
    @objc func handleRegistration(){
        print("sdsdsd")
        //print(UIApplication.topViewController())
//        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
//        delegate?.completeTwoTexts(vm: headerModel!)
        //print(UIApplication.topViewController())
        //dismiss(animated: true, completion: nil)
    }
    private let textView = CustomTextView()
    var viewModel :HeaderModel?
    var TextViewText: String?
    private var subscribers = Set<AnyCancellable>()
    weak var delegate : EditTextViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        textView.delegate = self
        configureNotificationObservers()
        //tapGesture()
        //observeForm()
        textViewDone()
        setupGestures()
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
        
        view.backgroundColor = UIColor(white: 0.3, alpha: 0.4)
        view.addSubview(containerView)
        
        containerView.layer.cornerRadius = 25
        containerView.centerX(inView: view)
        containerView.centerY(inView: view)
        containerView.setWidth(width: UIScreen.main.bounds.width - 50)
        containerView.backgroundColor = UIColor(displayP3Red: 239/255, green: 239/255, blue: 244/255, alpha: 1)
//        textView.text = TextViewText ?? ""
        textView.text = viewModel?.textViewText ?? ""
        let stackView = UIStackView(arrangedSubviews: [
            textView,
            completeButton
        ])
        stackView.axis = .vertical
        stackView.spacing = 6
        stackView.alignment = .center
        stackView.distribution = .fill
        containerView.addSubview(stackView)
        stackView.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 8)
        textView.layer.cornerRadius = 10
        textView.anchor(left: stackView.leftAnchor,  right: stackView.rightAnchor, paddingLeft: 2,paddingRight: 2, height: 240)
        completeButton.anchor( left: stackView.leftAnchor, right: stackView.rightAnchor, paddingLeft:0 , paddingRight:0)
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
    func configureNotificationObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillShowNotification, object: nil)//키보드 뜰때 --을 해라.
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func adjustInputView(noti:Notification) {
        
        guard let userInfo = noti.userInfo else { return }
        // [x] TODO: 키보드 높이에 따른 인풋뷰 위치 변경
        guard let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        if noti.name == UIResponder.keyboardWillShowNotification {
           
            print("go")
            let adjustmentHeight = keyboardFrame.height//원래 view.safeAreaInsets.bottom 이거 뺏다.
//            bigTextView.centerY(inView: containerView)
            print("1", keyboardFrame.height, view.safeAreaInsets.bottom)
            let viewPoint = view.bounds.height
            let completeButtonHeight = completeButton.bounds.height
            let completeButtonViewPoint = completeButton.convert(view.frame.origin, to: nil)
            
            let HeightFromTop = completeButtonHeight + completeButtonViewPoint.y
            let HeightFromBottom = viewPoint - HeightFromTop
            var diff:CGFloat = 0
            print("form bot", HeightFromBottom)
            if adjustmentHeight > HeightFromBottom {
                diff = adjustmentHeight - HeightFromBottom
            }
            print("총길이:",viewPoint)
            print("위에서 버튼까지",HeightFromTop)
            print("k",adjustmentHeight)
            print("diff",diff)
            if view.frame.origin.y == 0{
                        self.view.frame.origin.y -=  ( diff )
                    }//diff 는 맨아래 텍스트뷰 맨아래 위치와 키보드 올라올 때 부족한 차이.
            //if절이 없다면 계속 올린다.
            
//            print(viewPoint)
//            print(bigTextViewHeight)
//            print(bigTextViewPoint.y)
//            print(smallTextViewPoint.y)
//            containerView.centerY(inView: view, constant: <#T##CGFloat#>)
            
//            containerView.layoutIfNeeded()
//            view.layoutIfNeeded()
//            inputViewBottom.constant = adjustmentHeight
        } else if noti.name == UIResponder.keyboardWillHideNotification {
            if view.frame.origin.y != 0{
                        self.view.frame.origin.y = 0 //88픽셀 올려라.
                    }
            print("hide")
//            containerView.centerY(inView: view)
//            containerView.layoutIfNeeded()
//            view.layoutIfNeeded()
//            inputViewBottom.constant = 0
        }
//        if view.frame.origin.y == 0{
//            self.view.frame.origin.y -= 120 //88픽셀 올려라.화면이 올라가서 텍스트 가 좀 보이도록.
//        }
    }
    
    
    
    
}

extension EditTextViewController : UIGestureRecognizerDelegate {
    private func setupGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissViewController))
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
    }
    @objc private func dismissViewController(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        print("zz")
        return touch.view == self.view
    }
}
