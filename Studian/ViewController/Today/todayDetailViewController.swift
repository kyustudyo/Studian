//
//  EditTextViewController.swift
//  Studian
//
//  Created by 이한규 on 2021/10/29.
//

import Foundation
import UIKit
import Combine
import RxSwift
import RxCocoa

class todayDetailViewController : UIViewController, UITextViewDelegate{
    private let imageAndIndexSubject = PublishSubject<(UIImage,Int)>()
    var imageAndIndex: Observable<(UIImage,Int)> {
        return imageAndIndexSubject.asObservable()
    }
    
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
        button.addTarget(self, action: #selector(complete), for: .touchUpInside)
        return button
    }()
    
    @objc func complete(){
        dismiss(animated: true, completion: nil)//여기잇어도 되나?
        if isImageChanged {
            if let index = index, let image = image {
                imageAndIndexSubject.onNext((image,index))
            }
        }
    }
    
    var viewModel :HeaderModel?
    var image: UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        updateUI()
        configureNotificationObservers()
        setupGestures()
    }

    func updateUI(){
        
        view.backgroundColor = UIColor(white: 0.3, alpha: 0.4)
        view.addSubview(containerView)
        containerView.layer.cornerRadius = 25
        containerView.centerX(inView: view)
        containerView.centerY(inView: view)
        containerView.setWidth(width: UIScreen.main.bounds.width - 50)
        containerView.backgroundColor = UIColor(displayP3Red: 239/255, green: 239/255, blue: 244/255, alpha: 1)
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
        plusPhotoButton.anchor(top:stackView.topAnchor,paddingTop: 30)
        plusPhotoButton.anchor(bottom:completeButton.topAnchor,paddingBottom: 38)
        plusPhotoButton.setHeight(height: UIScreen.main.bounds.height/3)
        plusPhotoButton.setWidth(width: UIScreen.main.bounds.height/3)
        
        
        let image = self.image ?? UIImage(systemName: "circle")!//수정전 코드.
        let fixedImage = image.fixOrientation()//90도 회전하는 것 방지하는 코드.
        showLoadingAnimation()
        plusPhotoButton.setImage(fixedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        completeButton.anchor( left: stackView.leftAnchor, right: stackView.rightAnchor, paddingLeft:0 , paddingRight:0)
        hideLoadingAnimation()
    }

    func configureNotificationObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func adjustInputView(noti:Notification) {
        
        guard let userInfo = noti.userInfo else { return }
        guard let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        if noti.name == UIResponder.keyboardWillShowNotification {

            let adjustmentHeight = keyboardFrame.height//원래 view.safeAreaInsets.bottom 이거 뺏다.

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
            
            if view.frame.origin.y == 0{
                self.view.frame.origin.y -=  ( diff )
            }//diff 는 맨아래 텍스트뷰 맨아래 위치와 키보드 올라올 때
        } else if noti.name == UIResponder.keyboardWillHideNotification {
            if view.frame.origin.y != 0{
                self.view.frame.origin.y = 0 //88픽셀 올려라.
            }
        }

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
        return touch.view == self.view
    }
    
    
    @objc func handleSelectPhoto() {//처음 누를때
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

        plusPhotoButton.layer.borderColor = UIColor.white.cgColor
        plusPhotoButton.layer.cornerRadius = 15
        self.image = newImage
        isImageChanged = true
        dismiss(animated: true, completion: nil)
        //사진저장하기.
    }
}

