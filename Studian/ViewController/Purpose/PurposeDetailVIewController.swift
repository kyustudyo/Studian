//
//  PurposeDetailVIewControllse.swift
//  Studian
//
//  Created by 이한규 on 2021/10/22.
//

import UIKit
import Foundation
import Combine

protocol PurposeDetailVIewControllerDelegate : class {
    func changeDetail(purpose:Purpose,image:UIImage,indexInt:Int,isTextsChanged:Bool,isImageChanged:Bool)
}



class PurposeDetailVIewController: UIViewController,UIAnimatable,UITextViewDelegate {
    @Published private var bigTextView = CustomTextView()
    @Published private var smallTextView = CustomTextView()
    //var purposeAndImage : PurposeAndImage!//사용안함.
    var viewModel : PurposesViewModel!
    var index : Int!
    weak var delegate : PurposeDetailVIewControllerDelegate?
    private var subscribers = Set<AnyCancellable>()
    private var image = UIImage()
    private var isImageChanged = false
    private var isTextsChanged = false
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
        //button.layer.masksToBounds = true
        button.setHeight(height: 40)
        button.isEnabled = true
        button.addTarget(self, action: #selector(handleRegistration), for: .touchUpInside)
        return button
    }()
    
    
//    private let plusPhotoButton: UIButton = {
//        let button = UIButton(type: .system)
//        let image = UIImage(named: "2")?.withRoundedCorners(radius: UIScreen.main.bounds.width/2.5)
//        button.imageView?.contentMode = .scaleAspectFill//이거 안하면 좀 이상하게 나온다.
//        button.tintColor = .white
//        button.addTarget(self, action: #selector(handleSelectPhoto), for: .touchUpInside)
//        button.layer.cornerRadius = 15
//        button.clipsToBounds = true//이걸해야 동그라게 나온다. 안에들어갈 사진들이.
//        return button
//    }()
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
        //view.backgroundColor = .black
//        setSwipeGestures()
        configureUI()
        setupGestures()
        smallTextView.delegate = self
        bigTextView.delegate = self
        textViewDone()
        print("dididid")
        configureNotificationObservers()
        observeForm()
    }
    override func viewDidDisappear(_ animated: Bool) {
//        delegate?.completeTwoTexts(vm: headerModel!)
        guard let purpose = purpose else {
            return
        }
        
//        viewModel.updatePurpose(purpose)
//        self.delegate?.changeDetail()
        
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
            
            //self?.showLoadingAnimation()
            
            //viewModel.updatePurpose(purpose)

            //self?.delegate?.changeDetail()
            //self?.hideLoadingAnimation()
//            let purpose = Purpose(id: (self?.purposeAndImage.index)!, name: smallTextView.text ?? "", oneSenetence: text)
//            self?.purposeAndImage.purpose = purpose
//            self?.delegate?.Change(purposeAndImage: self?.purposeAndImage ?? PurposeAndImage(purpose: Purpose(id: -1, name: "", oneSenetence: ""), image: UIImage(), index: -1))
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
        // [x] TODO: 키보드 높이에 따른 인풋뷰 위치 변경
        guard let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        if noti.name == UIResponder.keyboardWillShowNotification {
           
            print("go")
            let adjustmentHeight = keyboardFrame.height//원래 view.safeAreaInsets.bottom 이거 뺏다.
//            bigTextView.centerY(inView: containerView)
            print("1", keyboardFrame.height, view.safeAreaInsets.bottom)
            let viewPoint = view.bounds.height
            let bigTextViewHeight = bigTextView.bounds.height
            print(bigTextViewHeight)
            let bigTextViewPoint = bigTextView.convert(view.frame.origin, to: nil)
            print(bigTextViewPoint)
            let smallTextViewPoint = completeButton.convert(view.frame.origin, to: nil)
            print(smallTextViewPoint)
            let smallTextViewHeight = completeButton.bounds.height
            print(smallTextViewPoint)
            let HeightFromTop = bigTextViewHeight + bigTextViewPoint.y
            let HeightFromBottom = viewPoint - HeightFromTop
            let diff = adjustmentHeight - HeightFromBottom
            print("k",adjustmentHeight)
            print(diff)
            if view.frame.origin.y == 0{
                        self.view.frame.origin.y -= diff
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
//    @objc func keyboardWillHide() {
//
//    }
    func configureUI() {
        
//        let stack = UIStackView(arrangedSubviews: [iconImage,smallTextView])
//        stack.axis = .horizontal
//        stack.spacing = 16
//        view.addSubview(stack)
        
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
//        view.addSubview(plusPhotoButton)
        
//        plusPhotoButton.anchor(top:view.safeAreaLayoutGuide.topAnchor,
//                         left: view.safeAreaLayoutGuide.leftAnchor,
//                         paddingTop: 16,
//                         paddingLeft: 16)//이 코드를 써야 여러종에도 맞게 코딩된다.
        plusPhotoButton.setHeight(height: UIScreen.main.bounds.height/3)
        plusPhotoButton.setWidth(width: UIScreen.main.bounds.height/3)
        bigTextView.setHeight(height: 60)
        smallTextView.setHeight(height: 60)
        bigTextView.anchor( left: stackView.leftAnchor, right: stackView.rightAnchor, paddingLeft:10 , paddingRight:10)
        smallTextView.anchor( left: stackView.leftAnchor, right: stackView.rightAnchor, paddingLeft:10 , paddingRight:10 )
        
        
       //iconImage.image = purposeAndImage?.image
        let image = viewModel.images[index]//수정전 코드.
        //guard let image = purposeAndImage.image else {return}//수정후 코드
        
        let fixedImage = image.fixOrientation()//90도 회전하는 것 방지하는 코드.
        showLoadingAnimation()
        plusPhotoButton.setImage(fixedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        hideLoadingAnimation()
        
//        print(viewModel.images)
//        print(viewModel.images[index])
        //plusPhotoButton.image = viewModel.images[index]
//        plusPhotoButton.setDimensions(height: UIScreen.main.bounds.width/2.3, width: UIScreen.main.bounds.width/2.3)
        
//        view.addSubview(smallTextView)
//        smallTextView.anchor(top:view.safeAreaLayoutGuide.topAnchor,
//                             left: plusPhotoButton.rightAnchor,
//
//                             right: view.safeAreaLayoutGuide.rightAnchor,
//                             paddingTop: 16,
//                             paddingLeft: 16,
//                             paddingRight: 16)
        smallTextView.text = viewModel.purposes[index].name//수정후 코드
//        smallTextView.text = purposeAndImage?.purpose?.name//수정전 코드
        smallTextView.isEditable = true
        
        //smallTextView.setDimensions(height: 100, width: 100)
//        view.addSubview(bigTextView)
//        bigTextView.anchor(top:plusPhotoButton.bottomAnchor,left: view.safeAreaLayoutGuide.leftAnchor,bottom: view.safeAreaLayoutGuide.bottomAnchor,right: view.safeAreaLayoutGuide.rightAnchor,paddingTop: 32,paddingLeft: 16,paddingBottom: 200,paddingRight: 16)
//        bigTextView.anchor(top:smallTextView.bottomAnchor,paddingTop: 32)
        bigTextView.text = viewModel.purposes[index].oneSenetence//수정후 코드
        //bigTextView.text = purposeAndImage?.purpose?.oneSenetence//수정전코드
        bigTextView.isEditable = true
        
        containerView.addSubview(stackView)
        stackView.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, paddingTop: 24, paddingLeft: 24, paddingBottom: 24, paddingRight: 24)
          
    }
    @IBAction func editPlz(_ sender: UIButton) {
        
        
    }
    @objc func handleRegistration(){
        print("sdsdsd")
        
        
        
        if let purpose = purpose {
            delegate?.changeDetail(purpose: purpose,image:image,indexInt: index, isTextsChanged: isTextsChanged, isImageChanged: isImageChanged)
        }
        dismiss(animated: true, completion: nil)
        
        //print(UIApplication.topViewController())
//        navigationController?.popViewController(animated: true)
        
//        delegate?.completeTwoTexts(vm: headerModel!)
        //print(UIApplication.topViewController())
        //dismiss(animated: true, completion: nil)
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
        print("zz")
        return touch.view == self.view
    }
    
    @objc func handleSelectPhoto() {//처음 누를때
        print("select")
        showLoadingAnimation()
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: hideLoadingAnimation)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as? UIImage
        let fixedImage = image?.fixOrientation()//90도 회전하는 것 방지하는 코드.
        plusPhotoButton.setImage(fixedImage?.withRenderingMode(.alwaysOriginal), for: .normal)
        
        
        
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
        
        if let fixedImage = fixedImage {
            self.image = fixedImage
            isImageChanged = true
        }
        
        dismiss(animated: true, completion: nil)
        //사진저장하기.
    }
    
    private func setSwipeGestures(){//사용안함.
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture(_ : )))
        swipeDown.direction = UISwipeGestureRecognizer.Direction.down
        self.view.addGestureRecognizer(swipeDown)
    }
    @objc func respondToSwipeGesture(_ gesture: UIGestureRecognizer){
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            print("!!")
            switch swipeGesture.direction {
            case .down :
                dismissViewController()
                print("down!")
            default: break
            }
        }
    }
    
    
}


