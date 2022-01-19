//
//  PurposeDetailVIewControllse.swift
//  Studian
//
//  Created by 이한규 on 2021/10/22.
//

import UIKit
import Foundation
import Combine
import RxCocoa
import RxSwift



class PurposeDetailVIewController: UIViewController,UIAnimatable,UITextViewDelegate {
    @Published private var bigTextView = CustomTextView()
    @Published private var smallTextView = CustomTextView()
    //var purposeAndImage : PurposeAndImage!//사용안함.
    var viewModel : PurposesViewModel!
    var index : Int!
    private var subscribers = Set<AnyCancellable>()
    private var image = UIImage()
    private var isImageChanged = false
    private var isTextsChanged = false
    
    private let detailViewModelSubject = PublishSubject<PurposeDatailViewModel>()
    var detailViewModel : Observable<PurposeDatailViewModel> {
        detailViewModelSubject.asObservable()
    }
    
    var purpose : Purpose?
    private let containerView : UIView = {
        let uiView = UIView()
        uiView.backgroundColor = .groupTableViewBackground
        return uiView
    }()
    private let completeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Complete!", for: .normal)
        button.layer.cornerRadius = 2
        
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        button.setHeight(height: 40)
        button.isEnabled = true
        button.addTarget(self, action: #selector(complete), for: .touchUpInside)
        return button
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

    override func viewDidLoad() {
        super.viewDidLoad()
        print("the overee")
        configureUI()
        setupGestures()
        smallTextView.delegate = self
        bigTextView.delegate = self
        textViewDone()
        configureNotificationObservers()
        observeForm()
    }
    
    func observeForm(){
        NotificationCenter.default.publisher(for: UITextView.textDidChangeNotification, object: smallTextView).compactMap {
            ($0.object as? UITextView)?.text
        }
        .sink { [weak self] (text) in
            guard let bigTextView = self?.bigTextView,
                  let viewModel = self?.viewModel,
                  let index = self?.index else {return}
            let purpose = Purpose(id:viewModel.purposes[index].id , name: text, oneSenetence: bigTextView.text)
            self?.isTextsChanged = true
            print(purpose)
            self?.purpose = purpose
        }.store(in: &subscribers)
        
        NotificationCenter.default.publisher(for: UITextView.textDidChangeNotification, object: bigTextView).compactMap {
            
            ($0.object as? UITextView)?.text
        }.sink { [weak self] (text) in

            print("\(text)")
            guard let smallTextView = self?.smallTextView,
                  let viewModel = self?.viewModel,
                  let index = self?.index else {return}
            let purpose = Purpose(id:viewModel.purposes[index].id , name: smallTextView.text, oneSenetence: text)
            self?.isTextsChanged = true
            print(purpose)
            self?.purpose = purpose

        }.store(in: &subscribers)
    }
    
    func textViewDone(){
        self.bigTextView.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        self.smallTextView.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
    }
    @objc func tapDone(sender: Any) {
            //print("done!!")
            self.view.endEditing(true)
        }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
                    textView.resignFirstResponder()
                    return false
                }
                return true
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        
        print("end")
    }
    func configureNotificationObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillShowNotification, object: nil)//키보드 뜰때 --을 해라.
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func adjustInputView(noti:Notification) {
        
        guard let userInfo = noti.userInfo else { return }
        guard let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        if noti.name == UIResponder.keyboardWillShowNotification {
            let bigTextViewHeight = bigTextView.bounds.height
            let bigTextViewPoint = bigTextView.convert(view.frame.origin, to: nil)
            let HeightFromTop = bigTextViewHeight + bigTextViewPoint.y
            let HeightFromBottom = view.bounds.height - HeightFromTop
            let diff = keyboardFrame.height - HeightFromBottom
            if view.frame.origin.y == 0{
                self.view.frame.origin.y -= diff
            }//diff 는 맨아래 텍스트뷰 맨아래 위치와 키보드 올라올 때 부족한 차이.
        } else if noti.name == UIResponder.keyboardWillHideNotification {
            if view.frame.origin.y != 0{
                self.view.frame.origin.y = 0
            }
        }
        
    }

    func configureUI() {

        view.backgroundColor = UIColor(white: 0.3, alpha: 0.4)
        self.view.addSubview(containerView)
        containerView.layer.cornerRadius = 25
        containerView.centerX(inView: view)
        containerView.centerY(inView: view)
        containerView.setWidth(width: UIScreen.main.bounds.width - 50)
         
        containerView.backgroundColor = UIColor(displayP3Red: 239/255, green: 239/255, blue: 244/255, alpha: 1)
        
        let stackView = UIStackView(arrangedSubviews: [
            plusPhotoButton,
            smallTextView,
            bigTextView,
            completeButton
        ])
        
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.alignment = .center
        stackView.distribution = .fill
        completeButton.anchor( left: stackView.leftAnchor, right: stackView.rightAnchor, paddingLeft:10 , paddingRight:10)
        plusPhotoButton.setHeight(height: UIScreen.main.bounds.height/3)
        plusPhotoButton.setWidth(width: UIScreen.main.bounds.height/3)
        bigTextView.setHeight(height: 60)
        smallTextView.setHeight(height: 60)
        bigTextView.anchor( left: stackView.leftAnchor, right: stackView.rightAnchor, paddingLeft:10 , paddingRight:10)
        smallTextView.anchor( left: stackView.leftAnchor, right: stackView.rightAnchor, paddingLeft:10 , paddingRight:10 )
        let image = viewModel.images[index]//수정전 코드.
        let fixedImage = image.fixOrientation()//90도 회전하는 것 방지하는 코드.
        showLoadingAnimation()
        plusPhotoButton.setImage(fixedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        hideLoadingAnimation()
        smallTextView.text = viewModel.purposes[index].name//수정후 코드
        smallTextView.isEditable = true
        bigTextView.text = viewModel.purposes[index].oneSenetence//수정후 코드
        bigTextView.isEditable = true
        
        containerView.addSubview(stackView)
        stackView.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, paddingTop: 24, paddingLeft: 24, paddingBottom: 24, paddingRight: 24)
          
    }
    @objc func complete(){
        if let purpose = purpose {
            
            detailViewModelSubject.onNext(PurposeDatailViewModel(purpose: purpose, image: image, indexInt: index, isTextsChagned: isTextsChanged, isImageChanged: isImageChanged))

        }
        dismiss(animated: true, completion: nil)
    }
}
extension PurposeDetailVIewController : UIImagePickerControllerDelegate & UINavigationControllerDelegate,UIGestureRecognizerDelegate {
    
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
    }
    
    private func setSwipeGestures(){//사용안함.
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture(_ : )))
        swipeDown.direction = UISwipeGestureRecognizer.Direction.down
        self.view.addGestureRecognizer(swipeDown)
    }
    @objc func respondToSwipeGesture(_ gesture: UIGestureRecognizer){
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case .down :
                dismissViewController()
            default: break
            }
        }
    }
    
    
}


