//
//  ViewController.swift
//  Studian
//
//  Created by 이한규 on 2021/10/22.
//

import UIKit
import MBProgressHUD

extension StudianMainPageViewController: PlusMainCellsDelegate,UIAnimatable {
    func cellChange() {
        print("ff")
        //showLoadingAnimation()
        reloadCell()
        editButtonHidden()//cell개수 8개로 제한
        //hideLoadingAnimation()
        clearTmpDirectory()
    }
    
    
}


class StudianMainPageViewController: UIViewController, EditTextViewControllerDelegate {
    @IBOutlet weak var editCellsBtn: UIButton!
    
    
    func change(text:String?) {
        headerModel.textViewText = text!
        collectionview.reloadSections(IndexSet(0..<1))
        //store(text, to: .documents, as: "PurposeTextViewText.txt")
        store(headerModel, to: .documents, as: "headerModel.txt") 
        print("\(text!)")
    }
    
//    @IBOutlet weak var txt1 : UILabel!
    @IBOutlet weak var collectionview: UICollectionView!
    //@IBOutlet weak var textView: UITextView!
    
    var headerModel = HeaderModel(textViewText: nil, textFieldText1: nil, textFieldText2: nil,headerImage: nil)
    var purposeViewModel = PurposesViewModel()
    
    
    
    func updateTintColor() {
        editButton.setTitleColor(DefaultStyle.Colors.tint, for: .normal)
        
        //editButton.tintColor = DefaultStyle.Colors.tint
        //editButton.backgroundColor = DefaultStyle.Colors.tint
        
        //timeSlider.tintColor = DefaultStyle.Colors.tint
    }
    
    lazy var editButton: UIButton = {
      let button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 60))
//        let configuration = UIImage.SymbolConfiguration(pointSize: 40)//사이즈조절등 스토리보드가면 잇다.
//        let image = UIImage(systemName: "pause.fill", withConfiguration: configuration)
//        button.setImage(image, for: .normal)
      button.setTitle("Edit", for: .normal)
        //button.setImage(<#T##image: UIImage?##UIImage?#>, for: <#T##UIControl.State#>)
      //button.setTitleColor(.blue, for: .normal)
        
//      button.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
      button.translatesAutoresizingMaskIntoConstraints = false
//        button.layer.borderWidth = 2
//        button.layer.borderColor = UIColor.blue.cgColor
//      button.layer.cornerRadius = 7
        
        
        
        
    
        
        
      button.addTarget(self, action: #selector(editSelector), for: .touchUpInside)
      return button
    }()
    
    @IBAction func EditTextViewBtn(_ sender: UIButton) {
        let navigationController = UINavigationController(rootViewController: EditTextViewController())
        let vc = navigationController.viewControllers.first! as? EditTextViewController
        vc?.viewModel = headerModel
        //vc?.TextViewText = headerViewModel
        vc?.delegate = self
        navigationController.modalPresentationStyle = UIModalPresentationStyle.automatic
        self.present(navigationController,animated: true,completion: nil)
  
    }
    
    @IBAction func EditCellsBtn(_ sender: UIButton) {
        //print(UIApplication.topViewController())
        print(PurposeManager.lastId)
        let navigationController = UINavigationController(rootViewController: PlusMainCellsViewController())
        let vc = navigationController.viewControllers.first! as? PlusMainCellsViewController
        vc?.delegate = self
        vc?.viewModel = purposeViewModel
        navigationController.modalPresentationStyle = UIModalPresentationStyle.automatic
        self.present(navigationController,animated: true,completion: nil)
        
        //print("btbt")
        
    
    }
    
    @IBAction func EditHeaderProfile(_ sender: UIButton) {
        print("headerprofile")
        let navigationController = UINavigationController(rootViewController: EditHedeaderProfileViewController())
        let vc = navigationController.viewControllers.first! as? EditHedeaderProfileViewController
        vc?.FirstTextField.text = headerModel.textFieldText1
        vc?.SecondTextField.text = headerModel.textFieldText2
        vc?.delegate = self
        vc?.headerModel = headerModel
        print(headerModel.headerImage)
//        vc?.TextViewText = headerViewModel.textViewText
//        vc?.delegate = self
        navigationController.modalPresentationStyle = UIModalPresentationStyle.automatic
        self.present(navigationController,animated: true,completion: nil)
    }
    
    
    @objc func editSelector(_ sender: UIButton) {
        if sender.isSelected == true {
            
            editCellsBtn.isHidden = true
            
            
            //print(editCellsBtn.isHidden)
            let baseColor = DefaultStyle.Colors.tint
            sender.setTitleColor(baseColor, for: .normal)
            setEditing(false, animated: false)//원래 override setEditing이란게 있다.
            sender.isSelected = false
        } else {
            if purposeViewModel.purposes.count < 8 {
            editCellsBtn.isHidden = false
            }
            //print(editCellsBtn.isHidden)
            sender.setTitleColor(UIColor.lightGray, for: .normal) //To change button Title colour .. check your button Tint color is clear_color..
            setEditing(true, animated: false)
            sender.isSelected = true
        }
        
        collectionview.allowsMultipleSelection = sender.isSelected
        print("시작 isediting: \(isEditing)")
        reloadCell()
        
    }
    func reloadCell(){
        print("reload")
        collectionview.reloadData()
    }
    
    
    
    func fetchHeaderTexts(){
        print("load!!")
        guard let a = retrive("headerModel.txt", from: .documents, as: HeaderModel.self) else {return}
        headerModel = a
        //headerModel.headerImage = 
        //headerViewModel.textViewText = retrive("headerModel.txt", from: .documents, as: TodayHeaderViewModel.self)?.textViewText
    
        
        print("\(headerModel.textViewText)")
    }
    
    
    
    func clearTmpDirectory(){
        FileManager.default.clearTmpDirectory()
    }
    func fetchHeaderImage(){
        print("fetch! header!")
        //showLoadingAnimation()
        let image = ImageFileManager.loadImageFromDocumentDirectory(fileName: "PurposePicture.png")
        //hideLoadingAnimation()
        headerModel.headerImage = image?.pngData()
    }
    
    override func viewDidLoad() {
       
        super.viewDidLoad()
        //showLoadingAnimation()
        firstTime()
        fetchHeaderTexts()
        fetchHeaderImage()
        clearTmpDirectory()
        updateTintColor()
        //tmpfile에 이미지 쌓이는것방지.
        //hideLoadingAnimation()
        //saveFile()
        //save연습.
//        let str = "strr"
//        let txt1 = getDocumentsDirectory().appendingPathComponent("new1.txt")
//        do {
//                   try str.write(to: txt1, atomically: true, encoding: .utf8)
//                   let input = try String(contentsOf: txt1)
//                   print(input)
//               } catch {
//                   print(error.localizedDescription)
//        }
        
        guard let _ = navigationController?.navigationBar.frame.height else {
                //print(navBarH)
            return
                        }
        
        //collectionview.contentInset = UIEdgeInsets(top: navBarH, left: 0, bottom: 0, right: 0)
        //collectionview.contentInsetAdjustmentBehavior = .never
        //버튼위치옮기는 코드 그러나 쓸 수 없다..
        //sendMailButton.transform = CGAffineTransform(translationX: 0, y: navBarH)
        navigationController?.navigationBar.topItem?.title = "Purpose"
         //navigationItem.rightBarButtonItem = UIBarButtonItem(customView: sendMailButton)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: editButton)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .automatic
        
        
        //print(loadFile(name: "new1.txt"))
        //아래는 사진 저장.
//        let uniqueFileName: String
//          = "\(ProcessInfo.processInfo.globallyUniqueString).jpeg"
//        ImageFileManager.shared
//          .saveImage(image: UIImage(systemName: "circle")!,
//                     name: uniqueFileName) { onSuccess in//weak self
//          print("saveImage onSuccess: \(onSuccess)")
//        }
        editCellsBtn.isHidden = true
        purposeViewModel.loadPurposes2()//cell들 정보 가져오기.

        
        
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //print("home")
    }
}

extension StudianMainPageViewController :UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
            let width: CGFloat = collectionView.frame.width
        var height: CGFloat = UIScreen.main.bounds.height/3.8
        if UIDevice.current.userInterfaceIdiom == .pad {
            height = 480
        }
            
            return CGSize(width: width, height: height)
        }
    //헤더 크기 커스텀해서 사진 안잘리도록.
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//
//        // Get the view for the first header
////        let indexPath = IndexPath(row: 0, section: section)
////        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
//
//        // Use this view to calculate the optimal size based on the collection view's width
//        return headerView.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width, height: collectionView.frame..height/4),
//                                                  withHorizontalFittingPriority: .required, // Width is fixed
//                                                  verticalFittingPriority: .fittingSizeLevel) // Height can be as large as needed
//    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return purposeViewModel.purposes.count
        //2배로해야한다.
    }
    
    //cell보여주기
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PurposeCell", for: indexPath) as? PurposeCellView else {return UICollectionViewCell()}
        
        
        cell.isInEditingMode = isEditing//delete 버튼 보이게
        
        let purpose = purposeViewModel.purposes[indexPath.item]
        let image = purposeViewModel.images[indexPath.item]
        
//        cell.updateUI(purpose: purposeViewModel.purposes[0])
        
        cell.updateUI(purpose: purpose,image: image)
        cell.deleteButtonTapHandler = {
            
            print(purpose.id)
            self.purposeViewModel.deletePurpose(purpose)
            self.purposeViewModel.deleteImage(purpose,index: indexPath.item)
            
            self.editButtonHidden()
            
            self.collectionview.reloadData()
        }
        return cell
    }
    func editButtonHidden(){
        if self.purposeViewModel.purposes.count < 8 {
        self.editCellsBtn.isHidden = false
        }
        else {
            self.editCellsBtn.isHidden = true
        }
    }
}

extension StudianMainPageViewController {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
//            guard let purpose = purposeViewModel.mainPurpose else {
//                return UICollectionReusableView()
//            }
            //let purpose = purposeViewModel.mainPurpose//바꿔야할듯.
            
            
            //커스텀셀을 가져오는 것처럼 커스텀 헤더 뷰를 가져온다.
            //헤더나 푸터의 경우 디큐리유서블 서플먼트해야한다.
            //헤더뷰.
            
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "PurposeHeaderView", for: indexPath) as? PurposeHeaderView else {
                return UICollectionReusableView()
            }
            
            
            header.purposeImageView?.image = UIImage(data: headerModel.headerImage ?? Data())
            
            
            //header.purposeImageView?.image = UIImage(systemName: "circle")!
            //header.updateForMainPage()
            //header.purposeImageView?.image = headerImage
            
            
            
            print("headererddddder")
            if isEditing {header.editMode = true}
            else {header.editMode = false}
            
            header.textView.text = headerModel.textViewText
            header.purposeName?.text = headerModel.textFieldText1
            header.Onesentence?.text = headerModel.textFieldText2
            header.headerModel = headerModel
            
            
            //
//            header.tapHandler = { item -> Void in
//                //player띄운다.
//                print("item:\(item.convertToTrack()?.title)")
//            }//이거 실행하면 헤더누르면 프린트된다.
            
            //교수
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

extension StudianMainPageViewController: EditHedeaderProfileDelegate {
    func completeTwoTexts(vm: HeaderModel) {
        headerModel.textFieldText1 = vm.textFieldText1
        headerModel.textFieldText2 = vm.textFieldText2
        
        print("끝났습니다\(headerModel.textFieldText1)")
        print("끝났습니다\(headerModel.textFieldText2)")
        //showLoadingAnimation()
        collectionview.reloadSections(IndexSet(0..<1))
        //showLoadingAnimation()
        store(headerModel, to: .documents, as: "headerModel.txt")
        //hideLoadingAnimation()
        //hideLoadingAnimation()
    }
    func completeMainPicture(vm: HeaderModel) {
        print("success")
        //showLoadingAnimation()
        //showLoadingAnimation()
        headerModel.headerImage = vm.headerImage
        collectionview.reloadSections(IndexSet(0..<1))
        //hideLoadingAnimation()
        //hideLoadingAnimation()
    }
}

//cell 클릭시

extension StudianMainPageViewController: UICollectionViewDelegate,PurposeDetailVIewControllerDelegate {
    func changeDetail() {
        print("chage")
        
        showLoadingAnimation()
        reloadCell()
        
        hideLoadingAnimation()
    }
    

    
    // 클릭했을때 어떻게 할까? 무엇을띄울까.
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(editButton.isSelected)
        //guard !(editButton.isSelected) else {return}//수정중일때는 못들어가도록.
        print("누를 때 player가도록 설정됨.")
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let detailVC = storyboard.instantiateViewController(withIdentifier: "PurposeDetailVIewController") as? PurposeDetailVIewController else {return}//스토리보드에서 연결 안해도 이거면 갈 수 있다.
        let purposeAndImage = purposeViewModel.purposeAndImage(id: indexPath.item)
        detailVC.purposeAndImage = purposeAndImage
        detailVC.viewModel = purposeViewModel
        detailVC.index = indexPath.item
        detailVC.delegate = self
//        guard let purpose = purposeViewModel.purposes[indexPath.item]  else {return}
            present(detailVC, animated: true, completion: nil)
            
        
//        playerVC.simplePlayer.replaceCurrentItem(with: item)

        
    }
}





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




