//
//  EditTextViewController.swift
//  Studian
//
//  Created by 이한규 on 2021/10/29.
//

import Foundation
import UIKit
import Combine

protocol TodayDetailViewControllerDelegate : class {
    func change(image: UIImage,index: Int)
}

class todayDetailViewController : UIViewController, UITextViewDelegate{
    
    private var isImageChanged = false
    var index : Int?
    private let containerView : UIView = {
        let uiView = UIView()
        uiView.backgroundColor = .groupTableViewBackground
        return uiView
    }()
    private let plusPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "2")
        button.imageView?.contentMode = .scaleAspectFill//이거 안하면 좀 이상하게 나온다.
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleSelectPhoto), for: .touchUpInside)
        button.layer.cornerRadius = 15
        button.clipsToBounds = true//이걸해야 동그라게 나온다. 안에들어갈 사진들이.
        return button
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
        dismiss(animated: true, completion: nil)//여기잇어도 되나?
        if isImageChanged{
            if let index = index {
                guard let image = image else{return}
                todayDetailViewControllerDelegate?.change(image: image,index: index)
            }
            
        }
        
        
        
//        delegate?.completeTwoTexts(vm: headerModel!)
        //print(UIApplication.topViewController())
        //dismiss(animated: true, completion: nil)
    }
//    private let textView = CustomTextView()
    
    
    var viewModel :HeaderModel?
    var image: UIImage?
    private var subscribers = Set<AnyCancellable>()
    weak var todayDetailViewControllerDelegate : TodayDetailViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        updateUI()
//        textView.delegate = self
        configureNotificationObservers()
        //tapGesture()
        //observeForm()
//        textViewDone()
        setupGestures()
    }
//    func textViewDone(){
//        self.textView.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
//    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
//         self.view.endEditing(true)
//   }//텍스트뷰말고 다른곳 클릭시 키보드내려감.
//    @objc func tapDone(sender: Any) {
//            self.view.endEditing(true)
//        }
    
//    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//        if(text == "\n") {
//                    textView.resignFirstResponder()
//                    return false
//                }
//                return true
//    }
    
    override func viewDidDisappear(_ animated: Bool) {
//        delegate?.change(text: textView.text)
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
//        textView.text = viewModel?.textViewText ?? ""
        let stackView = UIStackView(arrangedSubviews: [
            plusPhotoButton,
            completeButton
        ])
        stackView.axis = .vertical
        stackView.spacing = 6
        stackView.alignment = .center
        stackView.distribution = .fill
        containerView.addSubview(stackView)
        stackView.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 8)
//        textView.layer.cornerRadius = 10
//        textView.anchor(left: stackView.leftAnchor,  right: stackView.rightAnchor, paddingLeft: 2,paddingRight: 2, height: 240)
        plusPhotoButton.anchor(top:stackView.topAnchor,paddingTop: 30)
        plusPhotoButton.anchor(bottom:completeButton.topAnchor,paddingBottom: 38)
        plusPhotoButton.setHeight(height: UIScreen.main.bounds.height/3)
        plusPhotoButton.setWidth(width: UIScreen.main.bounds.height/3)
        
        
        let image = self.image ?? UIImage(systemName: "circle")!//수정전 코드.
        //guard let image = purposeAndImage.image else {return}//수정후 코드
        
        let fixedImage = image.fixOrientation()//90도 회전하는 것 방지하는 코드.
        showLoadingAnimation()
        plusPhotoButton.setImage(fixedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        
        completeButton.anchor( left: stackView.leftAnchor, right: stackView.rightAnchor, paddingLeft:0 , paddingRight:0)
//        textView.isEditable = true
        hideLoadingAnimation()
        
        
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

extension todayDetailViewController : UIGestureRecognizerDelegate,UIImagePickerControllerDelegate,UIAnimatable,
UINavigationControllerDelegate{
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
    
    
    @objc func handleSelectPhoto() {//처음 누를때
        print("select")
        showLoadingAnimation()
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: hideLoadingAnimation)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        let image = info[.originalImage] as? UIImage
//        let fixedImage = image?.fixOrientation()//90도 회전하는 것 방지하는 코드.
        
        var newImage = UIImage()
        if let possibleImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            newImage = possibleImage.fixOrientation() // 수정된 이미지가 있을 경우
        } else if let possibleImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            newImage = possibleImage.fixOrientation() // 원본 이미지가 있을 경우
        }
        
        
        
        
        
        plusPhotoButton.setImage(newImage.withRenderingMode(.alwaysOriginal), for: .normal)
        
        
        
        //viewModel?.headerImage = fixedImage!.pngData()
        
        //showLoadingAnimation()
        
//        viewModel.updateImage(purpose: viewModel.purposes[index], image: fixedImage!, index: index){
//            hideLoadingAnimation()
//        }
        
        //ImageFileManager.saveImageInDocumentDirectory(image: fixedImage!, fileName: "PurposePicture.png")
        plusPhotoButton.layer.borderColor = UIColor.white.cgColor
        //plusPhotoButton.layer.borderWidth = 3.0
        plusPhotoButton.layer.cornerRadius = 15
        
        
        //delegate?.changeDetail()
        
//        if let fixedImage = fixedImage {
//            self.image = fixedImage
//            isImageChanged = true
//        }
        self.image = newImage
        isImageChanged = true
        dismiss(animated: true, completion: nil)
        //사진저장하기.
    }
    
}

