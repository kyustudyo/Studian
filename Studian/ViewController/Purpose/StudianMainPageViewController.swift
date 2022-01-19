//
//  ViewController.swift
//  Studian
//
//  Created by 이한규 on 2021/10/22.
//

import UIKit
import MBProgressHUD
import RxSwift
import RxCocoa

class StudianMainPageViewController: UIViewController {
    
    // MARK: - Properties
    
    let disposeBag = DisposeBag()
    
    var headerModel = HeaderModel(textViewText: nil, textFieldText1: nil, textFieldText2: nil,headerImage: nil)
    var purposeViewModel = PurposesViewModel()
    
    var headerImage = UIImage()
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    @IBOutlet weak var collectionview: UICollectionView!
    @IBOutlet weak var editCellsBtn: UIButton!
    
    
    func updateTintColor() {
        editButton.setTitleColor(DefaultStyle.Colors.tint, for: .normal)
    }
    
    
    
    lazy var editButton: UIButton = {
      let button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 60))
//        let configuration = UIImage.SymbolConfiguration(pointSize: 40)//사이즈조절등 스토리보드가면 잇다.
      button.setTitle("Edit", for: .normal)
      button.translatesAutoresizingMaskIntoConstraints = false
      button.addTarget(self, action: #selector(editSelector), for: .touchUpInside)
      return button
    }()
    
    // MARK: - ButtonFunction
    
    @IBAction func EditTextViewBtn(_ sender: UIButton) {
        let navigationController = UINavigationController(rootViewController: EditTextViewController())
        let vc = navigationController.viewControllers.first! as? EditTextViewController
        vc?.viewModel = headerModel
        vc?.delegate = self
        
        vc?.modalPresentationStyle = .overFullScreen//full screen 하면 detailview에서 색깔 십힘
        navigationController.modalPresentationStyle = .overFullScreen
        self.present(navigationController,animated: true,completion: nil)
  
    }
    
    @IBAction func EditCellsBtn(_ sender: UIButton) {
        print(PurposeManager.lastId)
        let navigationController = UINavigationController(rootViewController: PlusMainCellsViewController())
        let vc = navigationController.viewControllers.first! as? PlusMainCellsViewController
        vc?.delegate = self
        vc?.viewModel = purposeViewModel
        navigationController.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        self.present(navigationController,animated: true,completion: nil)
    }
    
    @IBAction func EditHeaderProfile(_ sender: UIButton) {
        let navigationController = UINavigationController(rootViewController: EditHedeaderProfileViewController())
        let vc = navigationController.viewControllers.first! as? EditHedeaderProfileViewController

        vc?.FirstTextField.text = headerModel.textFieldText1
        vc?.SecondTextField.text = headerModel.textFieldText2
        vc?.delegate = self
        vc?.headerModel = headerModel
        print(headerModel.headerImage)
        navigationController.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        self.present(navigationController,animated: true,completion: nil)
    }
    
    // MARK: - Helpers
    
    @objc func editSelector(_ sender: UIButton) {
        if sender.isSelected == true {
            
            editCellsBtn.isHidden = true
            //print(editCellsBtn.isHidden)
            let baseColor = DefaultStyle.Colors.tint
            sender.setTitleColor(baseColor, for: .normal)
            setEditing(false, animated: false)//원래 override setEditing이란게 있다.
            sender.isSelected = false
        } else {
//            if purposeViewModel.purposes.count < 8 {
//            editCellsBtn.isHidden = false
//            }
            editCellsBtn.isHidden = !purposeViewModel.countIsValid
            
            sender.setTitleColor(UIColor.lightGray, for: .normal)
            setEditing(true, animated: false)
            sender.isSelected = true
        }
        
//        collectionview.allowsMultipleSelection = sender.isSelected
        reloadCell()
        
    }
    
    func reloadCell(){
        collectionview.reloadData()
    }
    
    
    
    func fetchHeaderTexts(){
        DispatchQueue.global().async {
            retrive(fileNavigation.header.fileName, from: .documents, as: HeaderModel.self){
                [weak self] header in
                DispatchQueue.main.async {
                    self?.headerModel = header
                    self?.collectionview.reloadData()
                }
            }
        }
            
        print("\(headerModel.textViewText)")
    }
    func clearTmpDirectory(){
        DispatchQueue.global().async {
            FileManager.default.clearTmpDirectory()
        }
    }
    
    func fetchHeaderImage(){
        DispatchQueue.global().async {
            ImageFileManager.loadImageFromDocumentDirectory(fileName: "PurposePicture.png",completion: {
                [weak self] image in
                DispatchQueue.main.async {
                    self?.headerModel.headerImage = image.pngData()
                    guard let data = self?.headerModel.headerImage,
                          let uiimage = UIImage(data: data) else {return}
                    self?.headerImage = uiimage
                    self?.collectionview.reloadData()
                }
            })
        }
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
       
        super.viewDidLoad()
        purposeViewModel.refactorIndexes()
        startIndicator()
        collectionview.alwaysBounceVertical = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        firstTime{
            
            self.fetchHeaderTexts()
            self.fetchHeaderImage()
            self.clearTmpDirectory()
            self.updateTintColor()
            
            guard let _ = self.navigationController?.navigationBar.frame.height else {
                return
            }
            
            self.editCellsBtn.isHidden = true
            self.purposeViewModel.loadPurposes2 { [weak self] in
                self?.reloadCell()


                self?.navigationController?.navigationBar.topItem?.title = "Purpose"

                self?.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self?.editButton ?? UIButton())
                self?.navigationController?.navigationBar.prefersLargeTitles = true
                self?.navigationController?.navigationItem.largeTitleDisplayMode = .automatic
                self?.stopIndicator()
            }//cell들 정보 가져오기.
        }
    }
    
}

// MARK: - EditTextViewControllerDelegate

extension StudianMainPageViewController: EditTextViewControllerDelegate {
    func change(text:String?) {
        
        headerModel.textViewText = text!
        showLoadingAnimation()
        let workGroup = DispatchGroup()
        DispatchQueue.global().async(group: workGroup) { [weak self] in
            store(self?.headerModel, to: .documents, as: .header)
        }
        workGroup.notify(queue: .main){ [weak self] in
            self?.collectionview.reloadData()
            self?.hideLoadingAnimation()
        }

    }
}
// MARK: - UICollectionViewDataSource

extension StudianMainPageViewController :UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
            let width: CGFloat = collectionView.frame.width
        var height: CGFloat = UIScreen.main.bounds.height/3.8
        if UIDevice.current.userInterfaceIdiom == .pad {
            height = 480
        }
            return CGSize(width: width, height: height)
        }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("count imgaes",purposeViewModel.images.count)
        return purposeViewModel.images.count
    }
    //cell보여주기
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PurposeCell", for: indexPath) as? PurposeCellView else {return UICollectionViewCell()}
        
        print("cell reload,\(indexPath.item)")
        cell.isInEditingMode = isEditing//delete 버튼 보이게
        let purpose = purposeViewModel.purposes[indexPath.item]
        let image = purposeViewModel.images[indexPath.item]
        cell.updateUI(purpose: purpose,image: image)
        cell.deleteButtonTapHandler = {
            self.purposeViewModel.deletePurpose(purpose)
            self.purposeViewModel.deleteImage(purpose,index: indexPath.item)
            self.editButtonHidden()
            self.collectionview.reloadData()
        }
        return cell
    }
    
    func editButtonHidden(){
//        if self.purposeViewModel.purposes.count < 8 {//아래 연산프로퍼티 이용.
//        if self.purposeViewModel.purposes.count < 10{
//            self.editCellsBtn.isHidden = false
//        }
//        else {
//            self.editCellsBtn.isHidden = true
//        }
        //아래를 통해 코드 단순화
        self.editCellsBtn.isHidden = !self.purposeViewModel.countIsValid
    }
}
// MARK: - HeaderCell
extension StudianMainPageViewController {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            //커스텀셀을 가져오는 것처럼 커스텀 헤더 뷰를 가져온다.
            //헤더나 푸터의 경우 디큐리유서블 서플먼트해야한다.
            //헤더뷰.
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "PurposeHeaderView", for: indexPath) as? PurposeHeaderView else {
                return UICollectionReusableView()
            }
             header.configure(img: headerImage)//data->uiimage 데이터 변환시간이 걸려서 로딩시간 걸리므로 다음과 같이 코딩하여 로딩없앴다.
            if isEditing {header.editMode = true}
            else {header.editMode = false}
            header.textView.text = headerModel.textViewText
            header.purposeName?.text = headerModel.textFieldText1
            header.Onesentence?.text = headerModel.textFieldText2
            header.headerModel = headerModel
            
            //headerview를 보면 있는데,여기서 뭔가 이동을 하기원하므로 여기 헨들러가 있는듯.
            print("taphanldddder")
            header.tapHandler = { headerModel in
                print("ttttt")
                let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                guard let detailVC = storyboard.instantiateViewController(withIdentifier: "PurposeDetailVIewController") as? PurposeDetailVIewController else {return}
                
//                let playerStoryboard = UIStoryboard.init(name: "Player", bundle: nil)
//                //Player는 저 아래에도 있다. Player는 파일이름.
//                guard let playerVC = playerStoryboard.instantiateViewController(identifier: "PlayerViewController") as? PlayerViewController else { return }
                //let item = trackManager.tracks[indexPath.item]
                //simplePlayer는 싱글톤.
               // header는 어디로가게 할까?
                //self.present(detailVC, animated: true, completion: nil)
            }
            //교수
            return header
        default:
            return UICollectionReusableView()
        }
    }
}
// MARK: - EditHedeaderProfileDelegate
extension StudianMainPageViewController: EditHedeaderProfileDelegate {
    func completeTextsOrImage(vm:HeaderModel,isTextsChanged:Bool,isImageChanged:Bool){
        
        showLoadingAnimation()
        
        let workGroup = DispatchGroup()
        
        if isImageChanged {
            guard let data = vm.headerImage,
                  let uiimage = UIImage(data: data) else {return}
            headerImage = uiimage
            headerModel.headerImage = vm.headerImage
            DispatchQueue.global().async(group: workGroup) {
                ImageFileManager.saveImageInDocumentDirectory(image: uiimage, fileName: "PurposePicture.png")
            }
        }
        
//        if isTextsChanged {//이걸 하면 이상해지네;; 연구필요.
            headerModel.textFieldText1 = vm.textFieldText1
            headerModel.textFieldText2 = vm.textFieldText2
            //collectionview.reloadData()//위에거 하면 깜박이는데 이거하면 깜박안함.
            DispatchQueue.global().async(group: workGroup) {
                store(self.headerModel, to: .documents, as: .header)
            }
//        }
        
        
        workGroup.notify(queue: .main){
            self.collectionview.reloadSections(IndexSet(0..<1))
            self.hideLoadingAnimation()
        }
        
    }
}

// MARK: - UICollectionViewDelegate

extension StudianMainPageViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let detailVC = storyboard.instantiateViewController(withIdentifier: "PurposeDetailVIewController") as? PurposeDetailVIewController else {return}//스토리보드에서 연결 안해도 이거면 갈 수 있다.

        detailVC.viewModel = purposeViewModel
        detailVC.index = indexPath.item
        detailVC.purpose = purposeViewModel.purposes[indexPath.row]
        detailVC.detailViewModel.subscribe(onNext:{ [weak self] in
            self?.showLoadingAnimation()
            let workGroup = DispatchGroup()
            let index = $0.indexInt
            let purpose = $0.purpose
            let image = $0.image
            
            if $0.isImageChanged {
                DispatchQueue.global().async(group:workGroup) { [weak self] in
                    self?.purposeViewModel.updateImage(purpose: purpose, image: image, index: index){
                            }
                }
            }
            if $0.isTextsChagned {
                DispatchQueue.global().async(group: workGroup) { [weak self] in
                    self?.purposeViewModel.updatePurpose(purpose)
                }
            }
            workGroup.notify(queue: .main){ [weak self] in
                self?.reloadCell()
                self?.hideLoadingAnimation()
            }
        
        }).disposed(by: disposeBag)
        
        detailVC.modalPresentationStyle = .overFullScreen//full
            present(detailVC, animated: true, completion: nil)

    }
}


// MARK: - UICollectionViewDelegateFlowLayout

extension StudianMainPageViewController: UICollectionViewDelegateFlowLayout {
    // 셀 사이즈 어떻게 할까?
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 20<좌측마진> - card(width) - 20<카드간간격> - card(width) - 20<오른쪽마진>
        //ㅣlet itemSpacing:CGFloat = 20
        //let margin: CGFloat = 20
        //let width = (collectionView.bounds.width - itemspacing - 2*margin)/2
        //let height = width + 60  //고정높이
        let width: CGFloat = (collectionView.bounds.width - (20 * 3))/2
        let height: CGFloat = width + 35
        return CGSize(width: width, height: height)
    }
    
}

// MARK: - PlusMainCellsDelegate

extension StudianMainPageViewController: PlusMainCellsDelegate,UIAnimatable {

    func PlusCell(purpose:Purpose,image:UIImage){
        showLoadingAnimation()
        purposeViewModel.addPurposeAndImage(purpose: purpose, image: image) { [weak self] in
            self?.editButtonHidden()
            self?.reloadCell()
            self?.clearTmpDirectory()
            self?.hideLoadingAnimation()
        }
        
    }
    
    
}


