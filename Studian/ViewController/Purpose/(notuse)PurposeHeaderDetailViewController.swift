////
////  PurposeDetailVIewControllse.swift
////  Studian
////
////  Created by 이한규 on 2021/10/22.
////
//
//import UIKit
//import Foundation
//import Combine
//
//protocol PurposeHeaderDetailViewControllerDelegate : class {
//    func changeDetail()
//}
//
//
//
//class PurposeHeaderDetailViewController: UIViewController,UIAnimatable {
//
//    @Published private var bigTextView = CustomTextView()
//    @Published private var smallTextView = CustomTextView()
//    var purposeAndImage : PurposeAndImage!
//
//    var purposeHeaderModel : HeaderModel!
//
//    var viewModel : PurposesViewModel!
//    var index : Int!
//
//    weak var delegate : PurposeDetailVIewControllerDelegate?
//    private var subscribers = Set<AnyCancellable>()
//
//    private let plusPhotoButton: UIButton = {
//        let button = UIButton(type: .system)
//        let image = UIImage(named: "2")?.withRoundedCorners(radius: UIScreen.main.bounds.width/2.5)
//        button.imageView?.contentMode = .scaleAspectFill//이거 안하면 좀 이상하게 나온다.
//        //button.setImage(image, for: .normal)
//        button.tintColor = .white
//        button.addTarget(self, action: #selector(handleSelectPhoto), for: .touchUpInside)
//        //button.imageView?.contentMode = .scaleAspectFill
//        button.layer.cornerRadius = 15
//        //button.imageView?.clipsToBounds = true
//        button.clipsToBounds = true//이걸해야 동그라게 나온다. 안에들어갈 사진들이.
//        return button
//    }()
//
////    private let iconImage: UIImageView = {
////        let iv = UIImageView()
////        iv.image = UIImage(named: "2")?.withRoundedCorners(radius: UIScreen.main.bounds.width/2.5)
////        //iv.layer.cornerRadius = iv.frame.size.width / 2
////        iv.tintColor = .white//이미지 색깔
////
////        //iv.layer.cornerRadius = iv.frame.size.width / 2
////        iv.layer.cornerRadius = 15
////        iv.clipsToBounds = true
////        return iv
////    }()
//
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .black
//        configureUI()
//        print("dididid")
//        observeForm()
//    }
//    func observeForm(){
//        NotificationCenter.default.publisher(for: UITextView.textDidChangeNotification, object: smallTextView).compactMap {
//            ($0.object as? UITextView)?.text
//        }
//
//        .sink { [weak self] (text) in
//            guard let bigTextView = self?.bigTextView,
//
//                  let viewModel = self?.viewModel,
//                  let index = self?.index else {return}
//
//
//            let purpose = Purpose(id:viewModel.purposes[index].id , name: text, oneSenetence: bigTextView.text)
//            print(purpose)
//
//            let header = HeaderModel(textViewText: self?.purposeHeaderModel.textViewText, textFieldText1: text, textFieldText2: bigTextView.text, headerImage: purposeHeaderModel.headerImage)
//
//            //self?.showLoadingAnimation()
//            viewModel.updatePurpose(purpose)
//
//
//
//            self?.delegate?.changeDetail()
//            //self?.hideLoadingAnimation()
//            //print("\(text)")
//
//        }.store(in: &subscribers)
//
//        NotificationCenter.default.publisher(for: UITextView.textDidChangeNotification, object: bigTextView).compactMap {
//
//
//            ($0.object as? UITextView)?.text
//        }.sink { [weak self] (text) in
//            //self?.initialInvetmentAmount = Int(text) ?? 0
//            //print("f")
//
//            print("\(text)")
//            guard let smallTextView = self?.smallTextView,
//                  let viewModel = self?.viewModel,
//                  let index = self?.index else {return}
//            let purpose = Purpose(id:viewModel.purposes[index].id , name: smallTextView.text, oneSenetence: text)
//            print(purpose)
//            //self?.showLoadingAnimation()
//            viewModel.updatePurpose(purpose)
//            self?.delegate?.changeDetail()
//            //self?.hideLoadingAnimation()
////            let purpose = Purpose(id: (self?.purposeAndImage.index)!, name: smallTextView.text ?? "", oneSenetence: text)
////            self?.purposeAndImage.purpose = purpose
////            self?.delegate?.Change(purposeAndImage: self?.purposeAndImage ?? PurposeAndImage(purpose: Purpose(id: -1, name: "", oneSenetence: ""), image: UIImage(), index: -1))
//        }.store(in: &subscribers)
//    }
//
//    func configureUI() {
//
////        let stack = UIStackView(arrangedSubviews: [iconImage,smallTextView])
////        stack.axis = .horizontal
////        stack.spacing = 16
////        view.addSubview(stack)
//
//        view.addSubview(plusPhotoButton)
//        plusPhotoButton.anchor(top:view.safeAreaLayoutGuide.topAnchor,
//                         left: view.safeAreaLayoutGuide.leftAnchor,
//                         paddingTop: 16,
//                         paddingLeft: 16)//이 코드를 써야 여러종에도 맞게 코딩된다.
//
//       //iconImage.image = purposeAndImage?.image
//        let image = viewModel.images[index]
//        let fixedImage = image.fixOrientation()//90도 회전하는 것 방지하는 코드.
//        showLoadingAnimation()
//        plusPhotoButton.setImage(fixedImage.withRenderingMode(.alwaysOriginal), for: .normal)
//        hideLoadingAnimation()
//
////        print(viewModel.images)
////        print(viewModel.images[index])
//        //plusPhotoButton.image = viewModel.images[index]
//        plusPhotoButton.setDimensions(height: UIScreen.main.bounds.width/2.3, width: UIScreen.main.bounds.width/2.3)
//
//        view.addSubview(smallTextView)
//        smallTextView.anchor(top:view.safeAreaLayoutGuide.topAnchor,
//                             left: plusPhotoButton.rightAnchor,
//
//                             right: view.safeAreaLayoutGuide.rightAnchor,
//                             paddingTop: 16,
//                             paddingLeft: 16,
//                             paddingRight: 16)
//        smallTextView.text = purposeAndImage?.purpose?.name
//        smallTextView.isEditable = true
//
//        //smallTextView.setDimensions(height: 100, width: 100)
//        view.addSubview(bigTextView)
//        bigTextView.anchor(top:plusPhotoButton.bottomAnchor,left: view.safeAreaLayoutGuide.leftAnchor,bottom: view.safeAreaLayoutGuide.bottomAnchor,right: view.safeAreaLayoutGuide.rightAnchor,paddingTop: 32,paddingLeft: 16,paddingBottom: 32,paddingRight: 16)
//        bigTextView.anchor(top:smallTextView.bottomAnchor,paddingTop: 32)
//        bigTextView.text = purposeAndImage?.purpose?.oneSenetence
//        bigTextView.isEditable = true
//
//    }
//
//
//
//    @IBAction func editPlz(_ sender: UIButton) {
//
//
//    }
//
//
//
//}
//
//extension PurposeHeaderDetailViewController : UIImagePickerControllerDelegate & UINavigationControllerDelegate {
//
//    @objc func handleSelectPhoto() {//처음 누를때
//        print("select")
//        let imagePickerController = UIImagePickerController()
//        imagePickerController.delegate = self
//        present(imagePickerController, animated: true, completion: nil)
//    }
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        let image = info[.originalImage] as? UIImage
//        let fixedImage = image?.fixOrientation()//90도 회전하는 것 방지하는 코드.
//        plusPhotoButton.setImage(fixedImage?.withRenderingMode(.alwaysOriginal), for: .normal)
//        //viewModel?.headerImage = fixedImage!.pngData()
//
//        showLoadingAnimation()
//        viewModel.updateImage(purpose: viewModel.purposes[index], image: fixedImage!, index: index){
//            hideLoadingAnimation()
//        }
//
//        //ImageFileManager.saveImageInDocumentDirectory(image: fixedImage!, fileName: "PurposePicture.png")
//        plusPhotoButton.layer.borderColor = UIColor.white.cgColor
//        //plusPhotoButton.layer.borderWidth = 3.0
//        plusPhotoButton.layer.cornerRadius = 15
//
//        dismiss(animated: true, completion: nil)
//        delegate?.changeDetail()
//        //사진저장하기.
//    }
//
//}
//
//
