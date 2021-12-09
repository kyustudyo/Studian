//
//  ViewController.swift
//  Studian
//
//  Created by 이한규 on 2021/10/22.
//

import UIKit
import MBProgressHUD

extension StudianMainPageViewController {
//    func startIndicator()
//    {
//        let bc = UIView()
//        bc.backgroundColor = .black
//        let uiimageview = UIImageView()
//        uiimageview.contentMode = .scaleAspectFill//없으면 찌그러져 보인다.
//        uiimageview.image = UIImage(named: "1024")
//        bc.addSubview(uiimageview)
//        //uiimageview.setDimensions(height: 200, width: 100)
//        uiimageview.centerX(inView: bc)
//        uiimageview.centerY(inView: bc)
//        uiimageview.setWidth(width: 200)
//        uiimageview.setHeight(height: 50)
//
//
//        //creating view to background while displaying indicator
////        let container: UIView = UIView()
////        container.frame = self.view.frame
////        container.center = self.view.center
////        container.center.y = self.view.center.y / 2
////        container.backgroundColor = container.backgroundColor
//
//
//
//        //creating view to display lable and indicator
//        let loadingView: UIView = UIView()
//        bc.addSubview(loadingView)
//        loadingView.setWidth(width: 118)
//        loadingView.setHeight(height: 80)
//        loadingView.anchor(top: uiimageview.bottomAnchor,paddingTop: 0)
//        loadingView.centerX(inView: bc)
//        loadingView.backgroundColor = .black
//        loadingView.clipsToBounds = true
//        loadingView.layer.cornerRadius = 10
//////
////        loadingView.frame = CGRect(x: 0, y: 0, width: 118, height: 80)
//////        bc.addSubview(loadingView)
////////        loadingView.center = self.view.center
//////        loadingView.anchor(top: uiimageview.bottomAnchor,paddingTop: 10)
//////        loadingView.centerY(inView: bc)
//////        loadingView.centerX(inView: bc)
//////        //loadingView.center.y = self.view.center.y / 2
////        loadingView.backgroundColor =  loadingView.backgroundColor
////        loadingView.clipsToBounds = true
////        loadingView.layer.cornerRadius = 10
//////
//////        //Preparing activity indicator to load
////        self.activityIndicator = UIActivityIndicatorView()
////        self.activityIndicator.frame = CGRect(x: 40, y: 12, width: 40, height: 40)
////        self.activityIndicator.style = UIActivityIndicatorView.Style.medium
////        loadingView.addSubview(activityIndicator)
//////
//////        //creating label to display message
////        let label = UILabel(frame: CGRect(x: 5, y: 55, width: 120, height: 20))
//        let label = UILabel()
//        label.text = "Loading..."
//        label.textColor = UIColor.white
////        label.font = UIFont.systemFont(ofSize: 25)
//        label.font = .init(name: "Jua-Regular", size: 15)
////        label.bounds = CGRect(x: 0, y: 0, width: loadingView.frame.size.width/2, height: loadingView.frame.size.height/2)
//        loadingView.addSubview(label)
//        label.anchor(top: loadingView.topAnchor, paddingTop: 5)
//        label.centerX(inView: loadingView)
////        print("k-1",loadingView.heightAnchor)
////        print("k0",loadingView.layer.bounds.width)
////        print("k1",loadingView.frame.height / 2,loadingView.frame.width / 2)
////        print("k2",loadingView.bounds.height / 2,loadingView.bounds.width / 2)
//        label.setDimensions(height: 20,width: 59)
////        label.setDimensions(height: 50, width: 30)
////        label.setHeight(height: 30)
////        label.setWidth(width: 50)
//
////        self.activityIndicator = UIActivityIndicatorView()
////        self.activityIndicator.style = UIActivityIndicatorView.Style.large
//
//
//        self.activityIndicator = UIActivityIndicatorView()
//        self.activityIndicator.style = UIActivityIndicatorView.Style.large
//        //let activityIndicator = UILabel()
//        //activityIndicator.text = "sdsd"
//        //activityIndicator.textColor = UIColor.white
//        loadingView.addSubview(activityIndicator)
//        activityIndicator.centerX(inView: loadingView)
//        activityIndicator.anchor(top: label.bottomAnchor, paddingTop: 0)
//        activityIndicator.setDimensions(height: 40, width: 40)
//
////
//////
////        label.bounds = CGRect(x: 0, y: 0, width: loadingView.frame.size.width/2, height: loadingView.frame.size.height/2)
////        label.font = UIFont.systemFont(ofSize: 12)
////        loadingView.addSubview(label)
//////
////////        container.addSubview(loadingView)
//////        bc.addSubview(loadingView)
////
////
////        bc.addSubview(loadingView)
////        loadingView.centerY(inView: uiimageview)
////        loadingView.centerX(inView: uiimageview)
//
////        self.view.addSubview(container)
//        self.view.addSubview(bc)
//        bc.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
//
//        self.activityIndicator.startAnimating()
//    }
//    func stopIndicator()
//    {
//        UIApplication.shared.endIgnoringInteractionEvents()
//            self.activityIndicator.stopAnimating()
//        ((self.activityIndicator.superview as UIView?)?.superview as UIView?)!.removeFromSuperview()
//    }
}

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
    var headerImage = UIImage()
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    func change(text:String?) {
        headerModel.textViewText = text!
        //collectionview.reloadSections(IndexSet(0..<1))//얘하면깜박임
        collectionview.reloadData()
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
        
//        guard let a = retrive("headerModel.txt", from: .documents, as: HeaderModel.self) else {return}
        
            retrive("headerModel.txt", from: .documents, as: HeaderModel.self){
                [weak self] header in
                DispatchQueue.main.async {
                    self?.headerModel = header
                    self?.collectionview.reloadData()
                }
                
            }
        
//        headerModel = a
        
        //headerModel.headerImage = 
        //headerViewModel.textViewText = retrive("headerModel.txt", from: .documents, as: TodayHeaderViewModel.self)?.textViewText
    
        
        print("\(headerModel.textViewText)")
    }
    
    
    
    func clearTmpDirectory(){
        DispatchQueue.global().async {
            FileManager.default.clearTmpDirectory()
        }
        
    }
    func fetchHeaderImage(){
        print("fetch! header!")
        //showLoadingAnimation()
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
        
        //hideLoadingAnimation()
        
        
    }
    
    override func viewDidLoad() {
       
        super.viewDidLoad()
        //showLoadingAnimation()
        //showLoadingAnimation()
        
//        let bc = UIView(frame: UIScreen.main.bounds)
//        let uiimageview = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
//        uiimageview.contentMode = .scaleAspectFill//없으면 찌그러져 보인다.
//        uiimageview.image = UIImage(named: "1024")
//        bc.addSubview(uiimageview)
//        bc.backgroundColor = .black
//        uiimageview.centerX(inView: bc)
//        uiimageview.centerY(inView: bc)
//        uiimageview.setWidth(width: 200)
//        uiimageview.setHeight(height: 100)
//        view.addSubview(bc)
        
//        if let window = UIApplication.shared.windows.first as UIWindow? {
//            window.backgroundColor = UIColor.red
//        }
        
        
        
        startIndicator()
//        showLoadingAnimation()
        MakeDummyPurpose()
        firstTime()
        fetchHeaderTexts()
        fetchHeaderImage()
        clearTmpDirectory()
        updateTintColor()
        
        //hideLoadingAnimation()
        
        
        
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
        
        
        
        //print(loadFile(name: "new1.txt"))
        //아래는 사진 저장.
//        let uniqueFileName: String
//          = "\(ProcessInfo.processInfo.globallyUniqueString).jpeg"
//        ImageFileManager.shared
//          .saveImage(image: UIImage(systemName: "circle")!,
//                     name: uniqueFileName) { onSuccess in//weak self
//          print("saveImage onSuccess: \(onSuccess)")
//        }
        print("?")
        editCellsBtn.isHidden = true
        purposeViewModel.loadPurposes2 { [weak self] in
            //bc.removeFromSuperview()
            //self?.view.backgroundColor = .clear
            self?.reloadCell()
            self?.stopIndicator()
            
            self?.navigationController?.navigationBar.topItem?.title = "Purpose"
             //navigationItem.rightBarButtonItem = UIBarButtonItem(customView: sendMailButton)
            self?.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self?.editButton ?? UIButton())
            self?.navigationController?.navigationBar.prefersLargeTitles = true
            self?.navigationController?.navigationItem.largeTitleDisplayMode = .automatic
            
            
            //self?.hideLoadingAnimation()
        }//cell들 정보 가져오기.
//        stopIndicator()
        
        
       print("ee")
        
        
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
        print("count imgaes",purposeViewModel.images.count)
        return purposeViewModel.images.count
        
        //2배로해야한다.
    }
    
    //cell보여주기
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PurposeCell", for: indexPath) as? PurposeCellView else {return UICollectionViewCell()}
        
        print("cell reload,\(indexPath.item)")
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
            
            print("header1111")
            //header.purposeImageView?.image = UIImage(data: headerModel.headerImage ?? Data())
             header.configure(img: headerImage)//data->uiimage 데이터 변환시간이 걸려서 로딩시간 걸리므로 다음과 같이 코딩하여 로딩없앴다.
            //header.configure2(data: headerModel.headerImage ?? Data())
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
        
        //collectionview.reloadSections(IndexSet(0..<1))//없애도되네?
        collectionview.reloadData()//위에거 하면 깜박이는데 이거하면 깜박안함.
       // collectionview.reloadItems(at: [IndexPath(index: 0)])
        
        //showLoadingAnimation()
        store(headerModel, to: .documents, as: "headerModel.txt")
        //hideLoadingAnimation()
        //hideLoadingAnimation()
    }
    
    func completeMainPicture(vm: HeaderModel) {
        print("success")
        //showLoadingAnimation()
        //showLoadingAnimation()
        //headerModel.headerImage = vm.headerImage
        
        guard let data = vm.headerImage,
                let uiimage = UIImage(data: data) else {return}
        headerImage = uiimage
        
        ImageFileManager.saveImageInDocumentDirectory(image: uiimage, fileName: "PurposePicture.png")
        
        collectionview.reloadSections(IndexSet(0..<1))
        
        //hideLoadingAnimation()
        //hideLoadingAnimation()
    }
}

//cell 클릭시

extension StudianMainPageViewController: UICollectionViewDelegate,PurposeDetailVIewControllerDelegate {
    func changeDetail() {
        print("chage")
        
        //showLoadingAnimation()
        reloadCell()
        //hideLoadingAnimation()
    }
    

    
    // 클릭했을때 어떻게 할까? 무엇을띄울까.
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(editButton.isSelected)
        //guard !(editButton.isSelected) else {return}//수정중일때는 못들어가도록.
        print("누를 때 player가도록 설정됨.")
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let detailVC = storyboard.instantiateViewController(withIdentifier: "PurposeDetailVIewController") as? PurposeDetailVIewController else {return}//스토리보드에서 연결 안해도 이거면 갈 수 있다.
        //let purposeAndImage = purposeViewModel.purposeAndImage(id: indexPath.item)
        //detailVC.purposeAndImage = purposeAndImage
        detailVC.viewModel = purposeViewModel
        detailVC.index = indexPath.item
        detailVC.delegate = self
        detailVC.modalPresentationStyle = .overFullScreen//full screen 하면 detailview에서 색깔 십힘
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




