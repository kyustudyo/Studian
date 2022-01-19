//
//  EditHedeaderProfileViewController.swift
//  Studian
//
//  Created by 이한규 on 2021/10/29.
//

import UIKit
import MBProgressHUD

protocol PlusMainCellsDelegate: class {
    func PlusCell(purpose:Purpose,image:UIImage)
}
class PlusMainCellsViewController : UIViewController, UIAnimatable{
    
    // MARK: - Properties
    
    weak var delegate : PlusMainCellsDelegate?
    weak var viewModel :PurposesViewModel?
    var purpose = Purpose(id: -1, name: "", oneSenetence: "")
    private let containerView : UIView = {
        let uiView = UIView()
        uiView.backgroundColor = .groupTableViewBackground
        return uiView
    }()
    
    private let plusPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "plus_photo"), for: .normal)
        button.imageView?.tag = -1
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleSelectPhoto), for: .touchUpInside)
        button.imageView?.contentMode = .scaleAspectFill
        button.layer.cornerRadius = 15
        //button.imageView?.clipsToBounds = true
        button.clipsToBounds = true//이걸해야 동그라게 나온다. 안에들어갈 사진들이.
        return button
    }()

    var FirstTextField = CustomTextField(placeholder: "Something")
    var SecondTextField = CustomTextField(placeholder: "Anything")
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
        button.addTarget(self, action: #selector(complete), for: .touchUpInside)
        return button
    }()
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("the overee")
        navigationController?.isNavigationBarHidden = true
        configureNotificationObservers()
        configureUI()
        tapGesture()
        //configureNotificationObservers()
    }

    func configureUI(){
        view.backgroundColor = UIColor(white: 0.3, alpha: 0.4)
        self.view.addSubview(containerView)
        containerView.layer.cornerRadius = 25
        containerView.centerX(inView: view)
        containerView.centerY(inView: view)
        containerView.setWidth(width: UIScreen.main.bounds.width - 50)
        containerView.backgroundColor = UIColor(displayP3Red: 239/255, green: 239/255, blue: 244/255, alpha: 1)
        let stackView = UIStackView(arrangedSubviews: [
            plusPhotoButton,
            FirstTextField,
            SecondTextField,
            completeButton
        ])
        
        plusPhotoButton.setHeight(height: UIScreen.main.bounds.height/3)
        plusPhotoButton.setWidth(width: UIScreen.main.bounds.height/3)
        
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.alignment = .center
        stackView.distribution = .fill
        completeButton.anchor( left: stackView.leftAnchor, right: stackView.rightAnchor, paddingLeft:10 , paddingRight:10)
        
        SecondTextField.setHeight(height: 40)
        FirstTextField.setHeight(height: 40)
        SecondTextField.anchor( left: stackView.leftAnchor, right: stackView.rightAnchor, paddingLeft:10 , paddingRight:10 )
        FirstTextField.anchor( left: stackView.leftAnchor, right: stackView.rightAnchor, paddingLeft:10 , paddingRight:10 )
        completeButton.anchor( left: stackView.leftAnchor, right: stackView.rightAnchor, paddingLeft:10 , paddingRight:10 )
        containerView.addSubview(stackView)
        stackView.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, paddingTop: 24, paddingLeft: 24, paddingBottom: 24, paddingRight: 24)

        plusPhotoButton.layer.cornerRadius = 15
    }
    
// MARK: Helpers
    
    @objc func complete(){
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
            let resultPurpose = PurposeManager.shared.createPurpose(name: purpose.name, oneSentence: purpose.oneSenetence)//id가 한번만 생길 수 있도록.
//            viewModel?.addPurpose(resultPurpose)
//            viewModel?.addImage(image)//파일저장까지 포함
            
            delegate?.PlusCell(purpose: resultPurpose, image: image)
        }
        dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - configureNotificationObservers

extension PlusMainCellsViewController {
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
            let adjustmentHeight = keyboardFrame.height//원래
            //            print("1", keyboardFrame.height, view.safeAreaInsets.bottom)
            let viewPoint = view.bounds.height
            let SecondTextFieldHeight = SecondTextField.bounds.height
            print(SecondTextFieldHeight)
            let SecondTextFieldPoint = SecondTextField.convert(view.frame.origin, to: nil)
            print(SecondTextFieldPoint)
            let smallTextViewPoint = completeButton.convert(view.frame.origin, to: nil)
            print(smallTextViewPoint)
            //            let smallTextViewHeight = completeButton.bounds.height
            print(smallTextViewPoint)
            let HeightFromTop = SecondTextFieldHeight + SecondTextFieldPoint.y
            let HeightFromBottom = viewPoint - HeightFromTop
            let diff = adjustmentHeight - HeightFromBottom
            if view.frame.origin.y == 0{
                self.view.frame.origin.y -= diff
            }//diff 는 맨아래 텍스트뷰 맨아래 위치와 키보드 올라올 때 부족한 차이.
            //if절이 없다면 계속 올린다.
        } else if noti.name == UIResponder.keyboardWillHideNotification {
            if view.frame.origin.y != 0{
                self.view.frame.origin.y = 0
            }
            
        }
    }
    
    @objc func textDidChange(sender: UITextField){
        if sender == FirstTextField {
            purpose = Purpose(id: -1, name: sender.text!, oneSenetence: SecondTextField.text!)//이렇게 안하고 아래처럼하면 누를때마다 id 올라간다.
        }
        else if sender == SecondTextField {
            purpose = Purpose(id: -1, name: FirstTextField.text!, oneSenetence: sender.text!)
        }
    }
}

// MARK: - UIImagePickerControllerDelegate

extension PlusMainCellsViewController : UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @objc func handleSelectPhoto() {//처음 누를때
        print("select")
        showLoadingAnimation()
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: hideLoadingAnimation)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var newImage = UIImage()
        if let possibleImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            newImage = possibleImage.fixOrientation() // 수정된 이미지가 있을 경우
        } else if let possibleImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            newImage = possibleImage.fixOrientation() // 원본 이미지가 있을 경우
        }
        plusPhotoButton.setImage(newImage.withRenderingMode(.alwaysOriginal), for: .normal)
        plusPhotoButton.imageView?.tag = 1
        plusPhotoButton.layer.borderColor = UIColor.white.cgColor
        plusPhotoButton.layer.borderWidth = 3.0
        plusPhotoButton.layer.cornerRadius = 50
//        print("current: ",plusPhotoButton.currentImage,plusPhotoButton.imageView?.tag)
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
}

// MARK: - UIGestureRecognizerDelegate

extension PlusMainCellsViewController :UIGestureRecognizerDelegate{
    func tapGesture(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissViewController))
        view.addGestureRecognizer(tap)
    }
    @objc func dismissViewController(){
//        view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view == self.view
    }
    
}
