//
//  EditHedeaderProfileViewController.swift
//  Studian
//
//  Created by 이한규 on 2021/10/29.
//

import UIKit
protocol EditHedeaderProfileDelegate: class {
//    func completeTwoTexts(vm:HeaderModel)
//    func completeMainPicture(vm: HeaderModel)
    func completeTextsOrImage(vm:HeaderModel,isTextsChanged:Bool,isImageChanged:Bool)
}

class EditHedeaderProfileViewController : UIViewController,UIAnimatable,UIGestureRecognizerDelegate{
    
    weak var delegate : EditHedeaderProfileDelegate?
    var headerModel :HeaderModel?
    private let containerView : UIView = {
        let uiView = UIView()
        uiView.backgroundColor = .groupTableViewBackground
        return uiView
    }()
    var isImageChanged = false
    var isTextsChagned = false
    private let plusPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        //button.setImage(#imageLiteral(resourceName: "plus_photo"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleSelectPhoto), for: .touchUpInside)
        button.imageView?.contentMode = .scaleAspectFill
        button.imageView?.clipsToBounds = true
        button.clipsToBounds = true//이걸해야 동그라게 나온다. 안에들어갈 사진들이.
        return button
    }()
    
    var FirstTextField = CustomTextField(placeholder: "Something")
//    private lazy var FirstContainerView: InputContainerView = {//lazy
//        return InputContainerView(image: UIImage(systemName: "doc.text.fill")
//                                               , textField: FirstTextField)
//    }()
    
    var SecondTextField = CustomTextField(placeholder: "Anything")
//    private lazy var SecondContainerView: InputContainerView = {//lazy
//        return InputContainerView(image: UIImage(systemName: "doc.text")
//                                               , textField: SecondTextField)
//    }()
    
    private let completeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Complete!", for: .normal)
        button.layer.cornerRadius = 2
        
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        //button.layer.masksToBounds = true
        button.setHeight(height: 40)
        button.isEnabled = true
        button.addTarget(self, action: #selector(handleRegistration), for: .touchUpInside)
        return button
    }()
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
//        guard let view =  self.view else {return false}
        print(touch.view,"!!", self.view, touch.view == self.view)
        return touch.view == self.view
    }
    
    @objc func handleRegistration(){//@@@
        print("sdsdsd")
        //print(UIApplication.topViewController())
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
        
        
        //
        if let headerModel = headerModel {
            delegate?.completeTextsOrImage(vm: headerModel, isTextsChanged: isTextsChagned, isImageChanged: isImageChanged)
        }
        
//        delegate?.completeTwoTexts(vm: headerModel!)
        
        
        //print(UIApplication.topViewController())
        //dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        configureUI()
        setupGestures()
        configureNotificationObservers()
//        tapGesture()
    }
    func tapGesture(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    func configureUI(){
        
        
        view.backgroundColor = UIColor(white: 0.3, alpha: 0.4)
        self.view.addSubview(containerView)
        containerView.layer.cornerRadius = 25
        containerView.centerX(inView: view)
        containerView.centerY(inView: view)
        containerView.setWidth(width: UIScreen.main.bounds.width - 50)
        //containerView.setHeight(height: 200)
        //containerView.backgroundColor = .red
        containerView.backgroundColor = UIColor(displayP3Red: 239/255, green: 239/255, blue: 244/255, alpha: 1)
        
        var stackView = UIStackView(arrangedSubviews: [
            plusPhotoButton,
            FirstTextField,
            SecondTextField,
            completeButton
        ])
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.alignment = .center
        stackView.distribution = .fill
        plusPhotoButton.setHeight(height: UIScreen.main.bounds.height/3)
        plusPhotoButton.setWidth(width: UIScreen.main.bounds.height/3)
        plusPhotoButton.backgroundColor = .clear
        SecondTextField.setHeight(height: 40)
        FirstTextField.setHeight(height: 40)
        SecondTextField.anchor( left: stackView.leftAnchor, right: stackView.rightAnchor, paddingLeft:10 , paddingRight:10 )
        FirstTextField.anchor( left: stackView.leftAnchor, right: stackView.rightAnchor, paddingLeft:10 , paddingRight:10 )
        completeButton.anchor( left: stackView.leftAnchor, right: stackView.rightAnchor, paddingLeft:10 , paddingRight:10 )
        containerView.addSubview(stackView)
        stackView.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, paddingTop: 24, paddingLeft: 24, paddingBottom: 24, paddingRight: 24)
        
        
        
        if let headerImage = headerModel?.headerImage {
            //plusPhotoButton.setImage(UIImage(data: headerImage), for: .normal)
            print(headerImage)
            let image = UIImage(data: headerImage)?.fixOrientation()
            plusPhotoButton.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)//withrenderingmode 안하면 안뜬다.
            //여기서 렉이 살짝 걸린다.
            
            //plusPhotoButton.layer.borderColor = UIColor.white.cgColor
            
            plusPhotoButton.layer.borderColor = UIColor.white.cgColor
            plusPhotoButton.layer.borderWidth = 3.0
            plusPhotoButton.layer.cornerRadius = 15
            
            //plusPhotoButton.setImage(UIImage(systemName: "heart"), for: .normal)
        } else {
            let image =  UIImage(named:"plus_photo")?.fixOrientation()
            plusPhotoButton.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)//withrenderingmode 안하면 안뜬다.

        }
        

    }
    
}

extension EditHedeaderProfileViewController {
    func configureNotificationObservers(){
        FirstTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        SecondTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillShowNotification, object: nil)//키보드 뜰때 --을 해라.
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    @objc func adjustInputView(noti:Notification) {
        guard let userInfo = noti.userInfo else { return }
        // [x] TODO: 키보드 높이에 따른 인풋뷰 위치 변경
        guard let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        if noti.name == UIResponder.keyboardWillShowNotification {
           
            print("go")
            let adjustmentHeight = keyboardFrame.height
//            bigTextView.centerY(inView: containerView)
            let viewPoint = view.bounds.height
            let FirstTextFieldHeight = FirstTextField.bounds.height
            let FirstTextFieldPoint = FirstTextField.convert(view.frame.origin, to: nil)
            let SecondTextFieldPoint =  completeButton.convert(view.frame.origin, to: nil)
            let SecondTextFieldHeight = completeButton.bounds.height
            
            let HeightFromTop = SecondTextFieldHeight + SecondTextFieldPoint.y
            let HeightFromBottom = viewPoint - HeightFromTop
            let diff = adjustmentHeight - HeightFromBottom
            print(adjustmentHeight)
            print(diff)
            if view.frame.origin.y == 0{
                        let doneButtonHeight = CGFloat(50)
                        self.view.frame.origin.y -=  ( diff - doneButtonHeight )
                    }//diff 는 맨아래 텍스트뷰 맨아래 위치와 키보드 올라올 때 부족한 차이.
            //if절이 없다면 계속 올린다.

        } else if noti.name == UIResponder.keyboardWillHideNotification {
            if view.frame.origin.y != 0{
                        self.view.frame.origin.y = 0 //88픽셀 올려라.
                    }
            print("hide")

        }

    }

    override func viewDidDisappear(_ animated: Bool) {//@@@
        //delegate?.completeTwoTexts(vm: headerModel!)
        //delegate?.completeMainPicture(vm: headerModel!)
        //dismiss(animated: true, completion: nil)
    }
    @objc func textDidChange(sender: UITextField){
        if sender == FirstTextField {
            headerModel?.textFieldText1 = sender.text
            print("\(headerModel?.textFieldText1)")
        } else if sender == SecondTextField {
            headerModel?.textFieldText2 = sender.text
            print("\(headerModel?.textFieldText2)")
        }
        isTextsChagned = true
//        delegate?.completeTwoTexts(vm: headerModel!)
        //checkFormStatus()//여기다하면 너무 느리다.
    }
}
extension EditHedeaderProfileViewController : UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @objc func handleSelectPhoto() {//처음 누를때
        print("select")
        showLoadingAnimation()
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: hideLoadingAnimation)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        showLoadingAnimation()
//        let image = info[.originalImage] as? UIImage
//        //profileImage = image//프사 변수에 저장.
//        let fixedImage = image?.fixOrientation()//90도 회전하는 것 방지하는 코드.
        
        
        var newImage = UIImage()
        if let possibleImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            newImage = possibleImage.fixOrientation() // 수정된 이미지가 있을 경우
        } else if let possibleImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            newImage = possibleImage.fixOrientation() // 원본 이미지가 있을 경우
        }
        
        //showLoadingAnimation()//  안먹힘
        plusPhotoButton.setImage(newImage.withRenderingMode(.alwaysOriginal), for: .normal)
        headerModel?.headerImage = newImage.pngData()
        
//        ImageFileManager.saveImageInDocumentDirectory(image: fixedImage!, fileName: "PurposePicture.png")
        //hideLoadingAnimation()
        
        plusPhotoButton.layer.borderColor = UIColor.white.cgColor
        plusPhotoButton.layer.borderWidth = 3.0
        plusPhotoButton.layer.cornerRadius = 50
        dismiss(animated: true, completion: nil)
        hideLoadingAnimation()
        
        isImageChanged = true
        
        
        //delegate?.completeMainPicture(vm: headerModel!)
        //사진저장하기.
    }
    
    
    
    
}

extension UIApplication {
    class func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}
