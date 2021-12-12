//
//  EditHedeaderProfileViewController.swift
//  Studian
//
//  Created by 이한규 on 2021/10/29.
//

import UIKit
import MBProgressHUD

protocol PlusMainCellsDelegate: class {
//    func cellChange()
    func PlusCell(purpose:Purpose,image:UIImage)
}
class PlusMainCellsViewController : UIViewController, UIAnimatable{
    
    weak var delegate : PlusMainCellsDelegate?
    weak var viewModel :PurposesViewModel?
    var purpose = Purpose(id: -1, name: "", oneSenetence: "")

    private let plusPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "plus_photo"), for: .normal)
        button.imageView?.tag = -1
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleSelectPhoto), for: .touchUpInside)
        button.imageView?.contentMode = .scaleAspectFill
        //button.imageView?.clipsToBounds = true
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
        navigationController?.popViewController(animated: true)//없어도된다.
        
        guard let image = plusPhotoButton.imageView?.image else {return}//플러스버튼에 이미지는 원래있다.
        if plusPhotoButton.imageView?.tag == 1 {//사진넣으면 태그 1되도록해놨다.
 
            let resultPurpose = PurposeManager.shared.createPurpose(name: purpose.name, oneSentence: purpose.oneSenetence)//id가 한번만 생길 수 있도록.

//            viewModel?.addPurpose(resultPurpose)
//            viewModel?.addImage(image)//파일저장까지 포함

            
            
            delegate?.PlusCell(purpose: resultPurpose, image: image)
            
        }
        //image nothing
        else {//태그가 -1 일때
            //이미지가 없는데 뭐라고 썼다면 이미지를 랜덤하게 만든다.
            print("사진없다.")
            print("현재 \(PurposeManager.lastId)")
            if purpose.name == "" && purpose.oneSenetence == "" {return}
            print("사진없는데 말이 있다")
            let image = UIImage(systemName: "circle")!

    //        guard let firstText = FirstTextField.text, firstText.isEmpty == false else {return}
            let resultPurpose = PurposeManager.shared.createPurpose(name: purpose.name, oneSentence: purpose.oneSenetence)//id가 한번만 생길 수 있도록.
//            viewModel?.addPurpose(resultPurpose)
//            viewModel?.addImage(image)//파일저장까지 포함
            
            delegate?.PlusCell(purpose: resultPurpose, image: image)
        }
        
//        delegate?.cellChange()
        
        
        
        
        
        dismiss(animated: true, completion: nil)
        //print(UIApplication.topViewController())
        //dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNotificationObservers()
        configureUI()
        tapGesture()
        //configureNotificationObservers()
    }
    
    func tapGesture(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    func configureUI(){
        view.backgroundColor = .darkGray
        view.addSubview(plusPhotoButton)
        view.addSubview(plusPhotoButton)
        plusPhotoButton.centerX(inView: view)
        plusPhotoButton.anchor(top:view.safeAreaLayoutGuide.topAnchor,paddingTop: 32)
        plusPhotoButton.setDimensions(height: 200, width: 200)
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

extension PlusMainCellsViewController {
    func configureNotificationObservers(){
        FirstTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        SecondTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)//키보드 뜰때 --을 해라.
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow() {
        if view.frame.origin.y == 0{
            self.view.frame.origin.y -= 88 //88픽셀 올려라.화면이 올라가서 텍스트 가 좀 보이도록.
        }
    }
    
    @objc func keyboardWillHide() {
        if view.frame.origin.y != 0{
            self.view.frame.origin.y = 0 //88픽셀 올려라.
        }
    }
    
    @objc func textDidChange(sender: UITextField){
        print("clcl")
        
        if sender == FirstTextField {
            purpose = Purpose(id: -1, name: sender.text!, oneSenetence: SecondTextField.text!)//이렇게 안하고 아래처럼하면 누를때마다 id 올라간다.
//            purpose = PurposeManager.shared.createPurpose(name: sender.text, oneSentence: FirstTextField.text)
            //viewModel?.textFieldText1 = sender.text
            //print("\(viewModel?.)")
        }
        else if sender == SecondTextField {
            purpose = Purpose(id: -1, name: FirstTextField.text!, oneSenetence: sender.text!)
//            purpose = PurposeManager.shared.createPurpose(name: SecondTextField.text, oneSentence: sender.text)
        }
//        viewModel?.addPurpose(purpose)
//        delegate?.completeTwoTexts(vm: viewModel!)
        //checkFormStatus()
        print(purpose)
    }
    override func viewDidDisappear(_ animated: Bool) {
        //guard let purpose = purpose else {return}
        //guard let purposeName = purpose.name else {return}
        //guard let purposeOnesentence = purpose.oneSenetence else {return}
        //타자 안쳐도 "" 로 들어가있어서 위에서는 안걸린다. 하지만 아래에서 isEmpty쓸때 옵셔널 아니어야하므로 guard let 쓴것
        //단 텍스트필드를 건드리지도 않으면 위에서 걸린다.
        //이미지가 있을때
//        guard let image = plusPhotoButton.imageView?.image else {return}//플러스버튼에 이미지는 원래있다.
//        if plusPhotoButton.imageView?.tag == 1 {//사진넣으면 태그 1되도록해놨다.
//            //print("\(plusPhotoButton.imageView?.image?.description)")
//            print("사진있다.")
//
//
//
//            let resultPurpose = PurposeManager.shared.createPurpose(name: purpose.name, oneSentence: purpose.oneSenetence)//id가 한번만 생길 수 있도록.
//
//
//
//            viewModel?.addPurpose(resultPurpose)
//            viewModel?.addImage(image)//파일저장까지 포함
//                //showLoadingAnimation()
////            ImageFileManager.saveImageInDocumentDirectory(image: image, fileName: "\(PurposeManager.lastId).png")
//           // hideLoadingAnimation()
//        }
//        //image nothing
//        else {//태그가 -1 일때
//            //이미지가 없는데 뭐라고 썼다면 이미지를 랜덤하게 만든다.
//            print("사진없다.")
//            print("현재 \(PurposeManager.lastId)")
//            if purpose.name == "" && purpose.oneSenetence == "" {return}
//            print("사진없는데 말이 있다")
//            let image = UIImage(systemName: "circle")!
//
//
//    //        guard let firstText = FirstTextField.text, firstText.isEmpty == false else {return}
//            let resultPurpose = PurposeManager.shared.createPurpose(name: purpose.name, oneSentence: purpose.oneSenetence)//id가 한번만 생길 수 있도록.
//            viewModel?.addPurpose(resultPurpose)
//            viewModel?.addImage(image)//파일저장까지 포함
//            //showLoadingAnimation()
//            //ImageFileManager.saveImageInDocumentDirectory(image: image, fileName: "\(PurposeManager.lastId).png")
//           // hideLoadingAnimation()
//
//        }
//
//        delegate?.cellChange()
        
        //print("disapper")
        
        
    }
}

extension PlusMainCellsViewController : UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @objc func handleSelectPhoto() {//처음 누를때
        print("select")
        showLoadingAnimation()
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: hideLoadingAnimation)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as? UIImage
        //profileImage = image//프사 변수에 저장.
        let fixedImage = image?.fixOrientation()//90도 회전하는 것 방지하는 코드.
        //showLoadingAnimation()
        plusPhotoButton.setImage(fixedImage?.withRenderingMode(.alwaysOriginal), for: .normal)
        //ImageFileManager.saveImageInDocumentDirectory(image: fixedImage!, fileName: "\(PurposeManager.lastId).png")
        //hideLoadingAnimation()
        plusPhotoButton.imageView?.tag = 1
        
        
//        ImageFileManager.saveImageInDocumentDirectory(image: fixedImage!, fileName: "PurposePicture.png")
        plusPhotoButton.layer.borderColor = UIColor.white.cgColor
        plusPhotoButton.layer.borderWidth = 3.0
        plusPhotoButton.layer.cornerRadius = 50
        print("current: ",plusPhotoButton.currentImage,plusPhotoButton.imageView?.tag)
        dismiss(animated: true, completion: nil)
        //delegate?.completeMainPicture()
        //사진저장하기.
    }
    
    
    
    
}
