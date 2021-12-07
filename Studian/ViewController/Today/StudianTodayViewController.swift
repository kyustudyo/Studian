//
//  StudianTodayViewController.swift
//  Studian
//
//  Created by 이한규 on 2021/10/24.
//

import Foundation
import UIKit


class StudianTodayViewController: UIViewController, tmpDelegate,UIAnimatable {
    func connectPlz(index:Int) {//텍스트필드 접근시 키보드 올리면 텍스트 필드 가려지므로 이것이 필수.
        print("almost done")
        //collectionview.scrollToItem(at: IndexPath(index: 0), at: .left, animated: true)
        print(index)
        //collectionview.selectItem(at: IndexPath(index: index), animated: true, scrollPosition: .centeredVertically)
        
        self.collectionview.scrollToItem(at:IndexPath(item: index, section: 0), at: .centeredVertically, animated: false)//이 코드가 아니라 scrollToItem(at:Indexpath(index:index),at: .left....) 이거로 하면안된다. 위의 것은 된다.
        
//        print(collectionview.scrollToItem(at: IndexPath(index: index), at: .centeredHorizontally, animated: false))
//        collectionview.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
    }
    @IBOutlet weak var img: UIImageView!
    
    
    //@IBOutlet weak var headerTxt: UILabel!
    @IBOutlet weak var plusCellsBtn: UIButton!
    
    let menuButton:MenuButton = {
        let menuButton = MenuButton()
        menuButton.backgroundColor = .clear
        return menuButton
    }()
    
    
    lazy var editButton: UIButton = {
      let button = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
      button.setTitle("Edit", for: .normal)
      button.setTitleColor(.blue, for: .normal)
//      button.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
      button.translatesAutoresizingMaskIntoConstraints = false
      button.layer.cornerRadius = 7
      button.addTarget(self, action: #selector(editSelector), for: .touchUpInside)
      return button
    }()
    
    lazy var saveButton: UIButton = {
        let button = UIButton(type: .system)
      button.setTitle("Save", for: .normal)
      button.setTitleColor(.blue, for: .normal)
//      button.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .regular)
      button.translatesAutoresizingMaskIntoConstraints = false
      button.layer.cornerRadius = 7
      button.addTarget(self, action: #selector(saveSelector), for: .touchUpInside)
      return button
    }()
    
    
    func reloadCell(){
        print("reload")
        collectionview.reloadData()
    }
    
    lazy var deleteButton: UIButton = {
      let button = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        button.setImage(UIImage(systemName: "trash.fill"), for: .normal)
        //button.setTitleColor(.blue, for: .normal)
        //button.setTitleColor(.red, for: .selected)
//      button.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
      button.translatesAutoresizingMaskIntoConstraints = false
      //button.layer.cornerRadius = 7
      button.addTarget(self, action: #selector(deleteSelector(_:)), for: .touchUpInside)
      return button
    }()
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 100
//    }
    
   
    @objc func deleteSelector(_ sender: UIButton){
        
    }//네비게이션 바 버튼
    
    @objc func saveSelector(_ sender: UIButton){
//        print(sender.isSelected)
//
//        sender.setTitleColor(.red, for: .selected)
        showLoadingAnimation()
        self.todayViewModel.saveTodays()
        hideLoadingAnimation()
        
    }
    @objc func editSelector(_ sender: UIButton) {
        if sender.isSelected == true {
            let baseColor = DefaultStyle.Colors.tint
            sender.setTitleColor(baseColor, for: .normal)
            setEditing(false, animated: false)//원래 override setEditing이란게 있다.
            sender.isSelected = false
        } else {
            sender.setTitleColor(UIColor.lightGray, for: .normal) //To change button Title colour .. check your button Tint color is clear_color..
            setEditing(true, animated: false)
            sender.isSelected = true
        }
        collectionview.allowsMultipleSelection = sender.isSelected
        print("시작 isediting: \(isEditing)")
        editButtonHidden()
        reloadCell()//이거있으면느려진다.
        
//        let indexPaths = collectionview.indexPathsForVisibleItems
//        for indexPath in indexPaths {
//            let cell = collectionview.cellForItem(at: indexPath) as! TodayCellView
//            cell.isInEditingMode = sender.isSelected
//            print("\(indexPath.row)에서 sender.isselcted:\(sender.isSelected)" )//처음누를때 모두 false 즉 isselected는 true
//        }
        
        
        
        //print("index: ", indexPaths)
            
        
        
        //print(isEditing)//항상flase?
        
    }
    
    
    
    
//    @objc func edit() {
//        print("Edit")
//        collectionview.allowsMultipleSelection = true
//        let indexPaths = collectionview.indexPathsForVisibleItems
//        for indexPath in indexPaths {
//            let cell = collectionview.cellForItem(at: indexPath) as! TodayCellView
//            cell.isInEditingMode = !cell.isInEditingMode
//            print(indexPath.row)
//        }
//
//
//
//
//    }
    
//    override func setEditing(_ editing: Bool, animated: Bool) {
//        print("Edit")
//    }
    
//    lazy var editButton : UIButton = {
//        guard let navBarH = navigationController?.navigationBar.frame.height else {fatalError()}
//        let suggestButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
//       suggestButton.setTitle("Edit", for: .normal)
//       suggestButton.setTitleColor(.black, for: .normal)
//       suggestButton.backgroundColor = .clear
//       suggestButton.layer.cornerRadius = 5
//       suggestButton.layer.borderWidth = 1
//       suggestButton.layer.borderColor = UIColor.black.cgColor
////        suggestButton.setBackgroundImage(suggestImage, for: .normal)
//       suggestButton.addTarget(self, action: #selector(Edit), for:.touchUpInside)
//        // here where the magic happens, you can shift it where you like
////       suggestButton.transform = CGAffineTransform(translationX: 0, y: navBarH)
//        // add the button to a container, otherwise the transform will be ignored
//
////        let suggestButtonContainer = UIImageView(frame: suggestButton.frame)
//        //suggestButton.isUserInteractionEnabled = true
//
////        suggestButtonContainer.addSubview(suggestButton)
//
//        //suggestButtonContainer.bringSubviewToFront(suggestButton)
////        let suggestButtonItem = UIBarButtonItem(customView: suggestButtonContainer)
//        //suggestButtonItem.customView = suggestButton
//
//
//        return suggestButton
//    }()
    
    @IBOutlet var collectionview: UICollectionView!
    
    //var purposeViewModel = PurposesViewModel()
    
    var todayViewModel = TodayViewModel()
    
    func updateTintColor() {
        editButton.setTitleColor(DefaultStyle.Colors.tint, for: .normal)//dark mode
        saveButton.setTitleColor(DefaultStyle.Colors.tint, for: .normal)
        //editButton.tintColor = DefaultStyle.Colors.tint
        //editButton.backgroundColor = DefaultStyle.Colors.tint
        
        //timeSlider.tintColor = DefaultStyle.Colors.tint
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //configureButton()//custom 버튼 일단 쓰지말자.
        //showLoadingAnimation()
        startIndicator()
        updateTintColor()
        observer()
        
        collectionview.alwaysBounceVertical = false
        
        
        
        
        
        editButtonHidden()//많으면 추가 못하게.
        
//        collectionview.frame = CGRect(x: collectionview.frame.origin.x, y: collectionview.frame.origin.y, width: collectionview.frame.size.width, height: collectionview.frame.size.height)
        collectionview.alwaysBounceVertical = false
        //헤더뷰 내리는 코드 그러나 쓸일 없다.
        guard let navBarH = navigationController?.navigationBar.frame.height else {
                //print(navBarH)
            return
                        }
        collectionview.contentInset = UIEdgeInsets(top: navBarH, left: 0, bottom: 0, right: 0)
        collectionview.contentInsetAdjustmentBehavior = .never
        //버튼위치옮기는 코드 그러나 쓸 수 없다..
        //sendMailButton.transform = CGAffineTransform(translationX: 0, y: navBarH)
        
        
        //purposeViewModel.loadPurposes2()
        
        todayViewModel.loadPurposes2(completion:
                                        
                                        { [weak self] in
            //self?.hideLoadingAnimation()
            self?.navigationController?.navigationBar.topItem?.title = "Today..."
            self?.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: self?.saveButton ?? UIButton())
            self?.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self?.editButton ?? UIButton())
            //navigationItem.leftBarButtonItem = UIBarButtonItem(customView: deleteButton)//제거 바 버튼
            self?.navigationController?.navigationBar.prefersLargeTitles = true
            self?.navigationController?.navigationItem.largeTitleDisplayMode = .automatic
            
            self?.stopIndicator()
            self?.collectionview.reloadData()})
        //hideLoadingAnimation()

        
        
    }
    
    
    
    func observer(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)//키보드 뜰때 --을 해라.
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow() {
        
        if view.frame.origin.y == 0{
            
            //self.view.frame.origin.y -= 88 //88픽셀 올려라.화면이 올라가서 텍스트 가 좀 보이도록.
            //네비게이션 바 위로 텍스트필드가 가면 클릭이안되서 없애버림
        }
    }
    @objc func keyboardWillHide() {
        if view.frame.origin.y != 0{
            //self.view.frame.origin.y = 0 //88픽셀 올려라.
        }
    }

    
    
    
    
//    @objc func Edit() {
//        print("edit")
//        print("qwe")
//    }
    override func viewDidDisappear(_ animated: Bool) {
        print("bybybyby")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //print("home")
//        print("?")
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        print("tototo")
        self.view.endEditing(true)
   }
    
    func configureButton(){
        view.addSubview(menuButton)
        menuButton.anchor(left:view.safeAreaLayoutGuide.leftAnchor,bottom:view.safeAreaLayoutGuide.bottomAnchor,paddingLeft: 15,paddingBottom: 10)
        menuButton.translatesAutoresizingMaskIntoConstraints = false
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        
//        let height = scrollView.frame.size.height
//        let contentYoffset = scrollView.contentOffset.y
//        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
//        if distanceFromBottom < height {
//
//            scrollView.alwaysBounceVertical = true
//            print(" you reached end of the table")
//        }
        
        
    }
}


extension StudianTodayViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return purposeViewModel.purposes.count
        return todayViewModel.todays.count
    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
//    }
//    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
////        self.collectionview.scrollToItem(at:IndexPath(item: 0, section: 0), at: .centeredVertically, animated: false)
//            print("okokok")
//    //        // handling code
//        }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row % 2 == 0{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TodayCell", for: indexPath) as? TodayCellView else {return UICollectionViewCell()}
            
            //let purpose = purposeViewModel.purposes[indexPath.item]
            let today = todayViewModel.todays[indexPath.item]
            print("count:",todayViewModel.images.count)
//            let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
            //cell.addGestureRecognizer(tap)
            
            
            
            //cell.updateUI(purpose: purpose)
            print(indexPath.row)
            cell.yPosition = Int(cell.layer.position.y)
            let image = todayViewModel.images[indexPath.row]
            cell.updateUI(today: today,image: image)
            cell.today = today
            
            cell.viewModel = todayViewModel
            cell.tmpDelegate = self
            cell.deleteButtonTapHandler = {
                print("d:",indexPath.row)
                self.todayViewModel.deleteToday(today)
                self.todayViewModel.deleteImage(index: indexPath.row)
                self.todayViewModel.deleteImage(index: indexPath.row+1)
                print("d:,",self.todayViewModel.images.count)
                self.editButtonHidden()
                self.collectionview.reloadData()
            }
            cell.isInEditingMode = isEditing
            //cell.removeBtn.isHidden = isEditing
            //cell.isInEditingMode =
            print("@@@@@position y , \(indexPath.row): ",cell.layer.position.y)
            print("isEditing: \(isEditing)")
            print("cell index@@@@@: \(indexPath.row)")
            
            //cell.contentView.isUserInteractionEnabled = false
            
            return cell
        }
        else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TodayCell2", for: indexPath) as? TodayCellView else {return UICollectionViewCell()}
            //cell.selectionStyle = .none
            return cell
        }
        
    }
    
}

extension StudianTodayViewController : UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func TodayCollectionChange() {
        print("")
    }
    
    
//    @objc func handleSelectPhoto() {//처음 누를때
//        print("select")
//        let imagePickerController = UIImagePickerController()
//        imagePickerController.delegate = self
//        present(imagePickerController, animated: true, completion: nil)
//    }
    @IBAction func plusCells(_ sender: UIButton) {
        
//        let navigationController = UINavigationController(rootViewController: PlusCellsViewController())
//        let vc = navigationController.viewControllers.first! as? PlusCellsViewController
//
//        //vc?.delegate = self
//        //vc?.viewModel = purposeViewModel
//        vc?.delegate = self
//        vc?.viewModel = todayViewModel
//        navigationController.modalPresentationStyle = UIModalPresentationStyle.automatic
//        self.present(navigationController,animated: true,completion: nil)
        
        print("select")
        showLoadingAnimation()
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: hideLoadingAnimation)
        
    }
    
    
    
    
    func editButtonHidden() {
        
        print(isEditing)
        if isEditing {
            if self.todayViewModel.todays.count < 10 {// x 2 해야하므로. 6개까지
            self.plusCellsBtn.isHidden = false
            }
            else {
                self.plusCellsBtn.isHidden = true
            }
        }
        else {
            self.plusCellsBtn.isHidden = true
        }
        
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as? UIImage
        //profileImage = image//프사 변수에 저장.
        guard let fixedImage = image?.fixOrientation() else {return}
                //90도 회전하는 것 방지하는 코드.
        
        let today = TodayManager.shared.createIndexAndData(image: fixedImage)
        todayViewModel.addToday(today)
        
        
        
        editButtonHidden()
        reloadCell()
        //showLoadingAnimation()
        //plusPhotoButton.setImage(fixedImage?.withRenderingMode(.alwaysOriginal), for: .normal)
        //ImageFileManager.saveImageInDocumentDirectory(image: fixedImage!, fileName: "\(PurposeManager.lastId).png")
        //hideLoadingAnimation()
        //plusPhotoButton.imageView?.tag = 1
        
        
//        ImageFileManager.saveImageInDocumentDirectory(image: fixedImage!, fileName: "PurposePicture.png")
//        plusPhotoButton.layer.borderColor = UIColor.white.cgColor
//        plusPhotoButton.layer.borderWidth = 3.0
//        plusPhotoButton.layer.cornerRadius = 50
       // print("current: ",plusPhotoButton.currentImage,plusPhotoButton.imageView?.tag)
        dismiss(animated: true, completion: nil)
        //delegate?.completeMainPicture()
        //사진저장하기.
    }
    
    
    
    
}

//extension StudianTodayViewController {
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        switch kind {
//        case UICollectionView.elementKindSectionHeader:
//            guard let purpose = purposeViewModel.mainPurpose else {
//                return UICollectionReusableView()
//            }
//
//
//
//            //커스텀셀을 가져오는 것처럼 커스텀 헤더 뷰를 가져온다.
//            //헤더나 푸터의 경우 디큐리유서블 서플먼트해야한다.
//            //헤더뷰.
//            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "TodayHeaderView", for: indexPath) as? PurposeHeaderView else {
//                return UICollectionReusableView()
//            }
//
//            //오늘의 곡 아이템 업데이트
//            header.updateForTodayPage()
//
//            //
////            header.tapHandler = { item -> Void in
////                //player띄운다.
////                print("item:\(item.convertToTrack()?.title)")
////            }//이거 실행하면 헤더누르면 프린트된다.
//
//            //교수
//            //headerview를 보면 있는데,여기서 뭔가 이동을 하기원하므로 여기 헨들러가 있는듯.
//            print("taphanlder")
////            header.tapHandler = { purpose in
////                let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
////                guard let detailVC = storyboard.instantiateViewController(withIdentifier: "PurposeDetailVIewController") as? PurposeDetailVIewController else {return}
////
//////                let playerStoryboard = UIStoryboard.init(name: "Player", bundle: nil)
//////                //Player는 저 아래에도 있다. Player는 파일이름.
//////                guard let playerVC = playerStoryboard.instantiateViewController(identifier: "PlayerViewController") as? PlayerViewController else { return }
////                //let item = trackManager.tracks[indexPath.item]
////                //simplePlayer는 싱글톤.
////
////                self.present(detailVC, animated: true, completion: nil)
////            }
//            //교수
//            return header
//        default:
//            return UICollectionReusableView()
//        }
//    }
//}

extension StudianTodayViewController: UICollectionViewDelegate {
    // 클릭했을때 어떻게 할까? 무엇을띄울까.
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        //reloadCell()
////        print("누를 때 player가도록 설정됨.")
//
//        collectionview.scrollToItem(at: IndexPath(index: 0), at: .left, animated: true)
//        print("clcl")
//
//        if isEditing == true {return}//수정중이면 클릭안되도록.
//
//        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
//        guard let detailVC = storyboard.instantiateViewController(withIdentifier: "PurposeDetailVIewController") as? PurposeDetailVIewController else {return}//스토리보드에서 연결 안해도 이거면 갈 수 있다.
//
////        guard let purpose = purposeViewModel.purposes[indexPath.item]  else {return}
//
//            present(detailVC, animated: true, completion: nil)
//
//
////        playerVC.simplePlayer.replaceCurrentItem(with: item)
//
//    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
    }
    
    
}




extension StudianTodayViewController: UICollectionViewDelegateFlowLayout {
    // 셀 사이즈 어떻게 할까?
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 20<좌측마진> - card(width) - 20<카드간간격> - card(width) - 20<오른쪽마진>
        //let itemSpacing:CGFloat = 20
        //let margin: CGFloat = 20
        //let width = (collectionView.bounds.width - itemspacing - 2*margin)/2
        //let height = width + 60  //고정높이
        
        
        
        if indexPath.row % 2 == 0 {
            let width: CGFloat = (collectionView.bounds.width - (20 * 2))
            let height: CGFloat = width/2.5
            
            return CGSize(width: width, height: height)
            
        }
        else {
            let width: CGFloat = (collectionView.bounds.width - (20 * 2))
//            let height: CGFloat = width/2.5
            var height = 10
            print("last", indexPath.row)
            print("\(todayViewModel.todays.count-1)")
            if indexPath.row == todayViewModel.todays.count-1 {
                height = 300
            }//마지막 셀의 아래에 큰 스페이스를 줘서 키보드 올라갈때 여유 생기게 한다.
            return CGSize(width: width, height: CGFloat(height))
            
        }
        
    }
}

