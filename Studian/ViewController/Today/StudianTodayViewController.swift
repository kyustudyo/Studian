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
        self.todayViewModel.saveTodays{ [weak self] in
            self?.hideLoadingAnimation()
        }
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
        
        
        showLoadingAnimation()
        reloadCell()//reload는 main에서만 해야한다.
        hideLoadingAnimation()
       
        

        
    }
    

    
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
        print("123",collectionview.isUserInteractionEnabled)
        collectionview.alwaysBounceVertical = false
        collectionview.dataSource = self
        collectionview.delegate = self
        
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
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        todayViewModel.loadPurposes2(completion:
                                        
                                        { [weak self] in
            //self?.hideLoadingAnimation()
            self?.navigationController?.navigationBar.topItem?.title = "Today..."
            self?.navigationController?.navigationBar.prefersLargeTitles = true
            self?.navigationController?.navigationItem.largeTitleDisplayMode = .always
            
            self?.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: self?.saveButton ?? UIButton())
            self?.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self?.editButton ?? UIButton())
            //navigationItem.leftBarButtonItem = UIBarButtonItem(customView: deleteButton)//제거 바 버튼
            
            
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
            print("dz:",indexPath.row)
            cell.delegate = self
            cell.viewModel = todayViewModel
            cell.tmpDelegate = self
            cell.deleteButtonTapHandler = {
                print("delete dz:",indexPath.row)
                self.todayViewModel.deleteToday(today)
                self.todayViewModel.deleteImage(index: indexPath.row)
//                self.todayViewModel.deleteImage(index: indexPath.row+1)
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
        
        print("select")
        showLoadingAnimation()
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: hideLoadingAnimation)
        
    }
    
    
    
    
    func editButtonHidden() {
        
        print(isEditing)
        if isEditing {
//            if self.todayViewModel.todays.count < 10 {// x 2 해야하므로. 6개까지
//            if self.todayViewModel.countOfItems < 20 {
//            self.plusCellsBtn.isHidden = false
//            }
//            else {
//                self.plusCellsBtn.isHidden = true
//            }
            plusCellsBtn.isHidden = !todayViewModel.countIsValid
        }
        else {
            self.plusCellsBtn.isHidden = true
        }
        
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true, completion: nil)
        showLoadingAnimation()
        let workGroup = DispatchGroup()
        DispatchQueue.global().async(group:workGroup) { [weak self] in
            let image = info[.originalImage] as? UIImage
            //profileImage = image//프사 변수에 저장.
//            guard let fixedImage = image?.fixOrientation() else {return}
                    //90도 회전하는 것 방지하는 코드.
            
            var newImage = UIImage()
            if let possibleImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
                newImage = possibleImage.fixOrientation() // 수정된 이미지가 있을 경우
            } else if let possibleImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                newImage = possibleImage.fixOrientation() // 원본 이미지가 있을 경우
            }
            let today = TodayManager.shared.createIndexAndData(image: newImage)
            self?.todayViewModel.addToday(today)
        }
        //todayViewModel.getTodo(today: <#T##Today#>, index: <#T##Int#>)
        workGroup.notify(queue: .main) { [weak self] in
            self?.editButtonHidden()
            self?.reloadCell()
            self?.hideLoadingAnimation()
        }
        
     
        
        //delegate?.completeMainPicture()
        //사진저장하기.
    }
    
    
    
    
}


extension StudianTodayViewController: UICollectionViewDelegate {
//    func change(image: UIImage) {
////        todayViewModel.updateTodo(today: <#T##Today#>, todo: <#T##Todo#>)
//        print(image)
//    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("index")
    }
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        print(editButton.isSelected)
//        //guard !(editButton.isSelected) else {return}//수정중일때는 못들어가도록.
//        print("누를 때 player가도록 설정됨.")
//
//        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
//        guard let detailVC = storyboard.instantiateViewController(withIdentifier: "PurposeDetailVIewController") as? todayDetailViewController else {return}//스토리보드에서 연결 안해도 이거면 갈 수 있다.
//        //let purposeAndImage = purposeViewModel.purposeAndImage(id: indexPath.item)
//        //detailVC.purposeAndImage = purposeAndImage
//        detailVC.image = todayViewModel.images[indexPath.row]
////        detailVC.viewModel = purposeViewModel
////        detailVC.index = indexPath.item
////        detailVC.purpose = purposeViewModel.purposes[indexPath.row]
//        detailVC.delegate = self
//        detailVC.modalPresentationStyle = .overFullScreen//full screen 하면 detailview에서 색깔 십힘
////        guard let purpose = purposeViewModel.purposes[indexPath.item]  else {return}
//
//
//            present(detailVC, animated: true, completion: nil)
//
//
////        playerVC.simplePlayer.replaceCurrentItem(with: item)
//
//
//    }
}
    
    

extension StudianTodayViewController : goToDetailDelegate,EditTodayDetailViewControllerDelegate {
    func change(image: UIImage,index: Int) {//2가 곱해진 인덱스
        print("ind",index)
        showLoadingAnimation()
        todayViewModel.editToday(image: image, index: index){ [weak self] in
            self?.reloadCell()
            self?.hideLoadingAnimation()
        }
        
    }
    
    func gotoDetailVC(image:UIImage,index:Int) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let detailVC = storyboard.instantiateViewController(withIdentifier: "todayDetailViewController") as? todayDetailViewController else {return}//스토리보드에서 연결 안해도 이거면 갈 수 있다.
        //let purposeAndImage = purposeViewModel.purposeAndImage(id: indexPath.item)
        //detailVC.purposeAndImage = purposeAndImage
        
        detailVC.image = todayViewModel.images[index]
        
        //                        detailVC.image = UIImage(systemName: "circle")
        
        detailVC.index = index
        
        //        detailVC.viewModel = purposeViewModel
        //        detailVC.index = indexPath.item
        //        detailVC.purpose = purposeViewModel.purposes[indexPath.row]
        detailVC.delegate = self
        detailVC.modalPresentationStyle = .overFullScreen//full screen 하면 detailview에서 색깔 십힘
        //        guard let purpose = purposeViewModel.purposes[indexPath.item]  else {return}
        
        
        present(detailVC, animated: true, completion: nil)
        
        
        //        playerVC.simplePlayer.replaceCurrentItem(with: item)
    }
    
    
}



extension StudianTodayViewController: UICollectionViewDelegateFlowLayout {
    // 셀 사이즈 어떻게 할까?
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 0
//    }
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

