//
//  EditHedeaderProfileViewController.swift
//  Studian
//
//  Created by 이한규 on 2021/10/29.
//

import UIKit
protocol EditHedeaderProfileDelegate: class {
    func completeTwoTexts(vm:HeaderModel)
    func completeMainPicture(vm: HeaderModel)
}

class EditHedeaderProfileViewController : UIViewController,UIAnimatable{
    
    weak var delegate : EditHedeaderProfileDelegate?
    weak var headerModel :HeaderModel?
    
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
    
    var FirstTextField = CustomTextField(placeholder: "Target")
    private lazy var FirstContainerView: InputContainerView = {//lazy
        return InputContainerView(image: UIImage(systemName: "doc.text.fill")
                                               , textField: FirstTextField)
    }()
    
    var SecondTextField = CustomTextField(placeholder: "Remind")
    private lazy var SecondContainerView: InputContainerView = {//lazy
        return InputContainerView(image: UIImage(systemName: "doc.text")
                                               , textField: SecondTextField)
    }()
    
    private let completeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Complete", for: .normal)
        button.layer.cornerRadius = 5
        
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.backgroundColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
        button.setTitleColor(.white, for: .normal)
        //button.layer.masksToBounds = true
        button.setHeight(height: 50)
        button.isEnabled = true
        button.addTarget(self, action: #selector(handleRegistration), for: .touchUpInside)
        return button
    }()
    
    @objc func handleRegistration(){
        print("sdsdsd")
        //print(UIApplication.topViewController())
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
        //print(UIApplication.topViewController())
        //dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNotificationObservers()
        tapGesture()
    }
    func tapGesture(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    func configureUI(){
        
        view.backgroundColor = .black
        view.addSubview(plusPhotoButton)
        view.addSubview(plusPhotoButton)
        
        if let headerImage = headerModel?.headerImage {
            //plusPhotoButton.setImage(UIImage(data: headerImage), for: .normal)
            print(headerImage)
            let image = UIImage(data: headerImage)?.fixOrientation()
            plusPhotoButton.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)//withrenderingmode 안하면 안뜬다.
            //plusPhotoButton.layer.borderColor = UIColor.white.cgColor
            
            plusPhotoButton.layer.borderColor = UIColor.white.cgColor
            plusPhotoButton.layer.borderWidth = 3.0
            plusPhotoButton.layer.cornerRadius = 50
            
            //plusPhotoButton.setImage(UIImage(systemName: "heart"), for: .normal)
        } else {
            let image =  UIImage(named:"plus_photo")?.fixOrientation()
            plusPhotoButton.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)//withrenderingmode 안하면 안뜬다.
            //plusPhotoButton.layer.borderColor = UIColor.white.cgColor
            
            //plusPhotoButton.layer.borderColor = UIColor.white.cgColor
            //plusPhotoButton.layer.borderWidth = 3.0
            //plusPhotoButton.layer.cornerRadius = 50
        }
        
        plusPhotoButton.centerX(inView: view)
        plusPhotoButton.anchor(top:view.safeAreaLayoutGuide.topAnchor,paddingTop: 32)
        plusPhotoButton.setDimensions(height: 250, width: 250)
        
        let stack = UIStackView(arrangedSubviews: [FirstContainerView,SecondContainerView])
        stack.axis = .vertical
        stack.spacing = 16
        view.addSubview(stack)
        stack.anchor(top:plusPhotoButton.bottomAnchor,left:view.leftAnchor, right: view.rightAnchor,paddingTop: 32, paddingLeft: 32, paddingRight: 32)
        view.addSubview(completeButton)
        completeButton.anchor(bottom:view.safeAreaLayoutGuide.bottomAnchor,paddingBottom: 32)
        completeButton.centerX(inView: view)
    }
    
}

extension EditHedeaderProfileViewController {
    func configureNotificationObservers(){
        FirstTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        SecondTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)//키보드 뜰때 --을 해라.
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow() {
        if view.frame.origin.y == 0{
            self.view.frame.origin.y -= 120 //88픽셀 올려라.화면이 올라가서 텍스트 가 좀 보이도록.
        }
    }
    @objc func keyboardWillHide() {
        if view.frame.origin.y != 0{
            self.view.frame.origin.y = 0 //88픽셀 올려라.
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        delegate?.completeTwoTexts(vm: headerModel!)
    }
    @objc func textDidChange(sender: UITextField){
        if sender == FirstTextField {
            headerModel?.textFieldText1 = sender.text
            print("\(headerModel?.textFieldText1)")
        } else if sender == SecondTextField {
            headerModel?.textFieldText2 = sender.text
            print("\(headerModel?.textFieldText2)")
        }
//        delegate?.completeTwoTexts(vm: headerModel!)
        //checkFormStatus()//여기다하면 너무 느리다.
    }
}
extension EditHedeaderProfileViewController : UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @objc func handleSelectPhoto() {//처음 누를때
        print("select")
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as? UIImage
        //profileImage = image//프사 변수에 저장.
        let fixedImage = image?.fixOrientation()//90도 회전하는 것 방지하는 코드.
        
        showLoadingAnimation()
        plusPhotoButton.setImage(fixedImage?.withRenderingMode(.alwaysOriginal), for: .normal)
        headerModel?.headerImage = fixedImage!.pngData()
        ImageFileManager.saveImageInDocumentDirectory(image: fixedImage!, fileName: "PurposePicture.png")
        hideLoadingAnimation()
        
        plusPhotoButton.layer.borderColor = UIColor.white.cgColor
        plusPhotoButton.layer.borderWidth = 3.0
        plusPhotoButton.layer.cornerRadius = 50
        dismiss(animated: true, completion: nil)
        delegate?.completeMainPicture(vm: headerModel!)
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
