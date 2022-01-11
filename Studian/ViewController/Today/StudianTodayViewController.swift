//
//  StudianTodayViewController.swift
//  Studian
//
//  Created by 이한규 on 2021/10/24.
//

import Foundation
import UIKit

private let TodayCell = "TodayCell"
private let TodayCell2 = "TodayCell2"
class StudianTodayViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var plusCellsBtn: UIButton!
    private let todayViewModel = TodayViewModel()

    lazy var editButton: UIButton = {
      let button = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
      button.setTitle("Edit", for: .normal)
      button.setTitleColor(.blue, for: .normal)
      button.translatesAutoresizingMaskIntoConstraints = false
      button.layer.cornerRadius = 7
      button.addTarget(self, action: #selector(editSelector), for: .touchUpInside)
      return button
    }()
    
    lazy var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Save", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .regular)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 7
        button.addTarget(self, action: #selector(saveSelector), for: .touchUpInside)
      return button
    }()
    
    func reloadCell(){
        collectionview.reloadData()
    }
    @objc func saveSelector(_ sender: UIButton){
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
            sender.setTitleColor(UIColor.lightGray, for: .normal)
            setEditing(true, animated: false)
            sender.isSelected = true
        }
        collectionview.allowsMultipleSelection = sender.isSelected
        editButtonHidden()
        showLoadingAnimation()
        reloadCell()//reload는 main에서만 해야한다.
        hideLoadingAnimation()
    }
 
    @IBOutlet var collectionview: UICollectionView!
    
    func prepareDarkMode() {
        editButton.setTitleColor(DefaultStyle.Colors.tint, for: .normal)//dark mode
        saveButton.setTitleColor(DefaultStyle.Colors.tint, for: .normal)//dark mode
    }
    
    func configureUI(){
        collectionview.alwaysBounceVertical = true
        self.navigationController?.navigationItem.largeTitleDisplayMode = .always
        self.navigationController?.navigationBar.prefersLargeTitles = true//아래 말고 여기에 선언해야 들어오자마자 크게 유지됨.
    }
//    func checkUserDefaults(){
//        let defaults = UserDefaults.standard
//        let data = StorageManager().isOnboardingSeen()
//        print("Debug: isOnboardingSeen:", data)
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        checkUserDefaults()
        print("debug: getDate:",StorageManager().getLastOpenDate())
        
        startIndicator()//custom
        prepareDarkMode()
        editButtonHidden()//많으면 추가 못하게.
        configureUI()
        todayViewModel.loadPurposes(completion:
                                        { [weak self] in
            guard let this = self else {return}
            this.navigationController?.navigationBar.topItem?.title = "Today..."
            this.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: this.saveButton ?? UIButton())
            this.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: this.editButton ?? UIButton())
            
            this.stopIndicator()
            this.collectionview.reloadData()})
    }
}


extension StudianTodayViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return todayViewModel.todays.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row % 2 == 0{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TodayCell, for: indexPath) as? TodayCellView else {
                return UICollectionViewCell()
            }
            
            let today = todayViewModel.todays[indexPath.row]
            let image = todayViewModel.images[indexPath.row]
            
            cell.indexRow = indexPath.row
//            cell.updateUI()
//            cell.today = today
            
            cell.goToDetailDelegate = self
//            cell.viewModel = todayViewModel
            cell.todayCellCenterDelegate = self//center
            cell.deleteButtonTapHandler = {
                self.todayViewModel.deleteToday(today)
                self.todayViewModel.deleteImage(index: indexPath.row)
                self.editButtonHidden()
                self.collectionview.reloadData()
            }
            cell.isInEditingMode = isEditing
            return cell
        }
        else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TodayCell2, for: indexPath) as? TodayCellView else {return UICollectionViewCell()}
            return cell
        }
    }
}

extension StudianTodayViewController : UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    @IBAction func plusCells(_ sender: UIButton) {
        
        print("select")
        showLoadingAnimation()
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: hideLoadingAnimation)
        
    }

    func editButtonHidden() {
//        print(isEditing)
        if isEditing {
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
            var newImage = UIImage()
            if let possibleImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
                newImage = possibleImage.fixOrientation() // 수정된 이미지가 있을 경우
            } else if let possibleImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                newImage = possibleImage.fixOrientation() // 원본 이미지가 있을 경우
            }
            let today = TodayManager.shared.createIndexAndData(image: newImage)
            self?.todayViewModel.addToday(today)
        }
        workGroup.notify(queue: .main) { [weak self] in
            self?.editButtonHidden()
            self?.reloadCell()
            self?.hideLoadingAnimation()
        }
    }
}

extension StudianTodayViewController : GoToDetailDelegate,TodayDetailViewControllerDelegate {
    
    func gotoDetailVC(image:UIImage,index:Int) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let detailVC = storyboard.instantiateViewController(withIdentifier: "todayDetailViewController") as? todayDetailViewController else {return}//스토리보드에서 연결 안해도 이거면 갈 수 있다.
        
        detailVC.image = todayViewModel.images[index]
        detailVC.index = index
        detailVC.todayDetailViewControllerDelegate = self
        detailVC.modalPresentationStyle = .overFullScreen//full screen 하면 detailview에서 색깔 십힘
        present(detailVC, animated: true, completion: nil)

    }
    //today detail view controller
    func change(image: UIImage,index: Int) {//2가 곱해진 인덱스
        showLoadingAnimation()
        todayViewModel.editToday(image: image, index: index){ [weak self] in
            self?.reloadCell()
            self?.hideLoadingAnimation()
        }
    }
}



extension StudianTodayViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
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
// MARK: - tmpDelegate
extension StudianTodayViewController : TodayCellCenterDelegate {
    func DoCollectionViewCenter(index:Int) {//텍스트필드 접근시 키보드 올리면
        self.collectionview.scrollToItem(at:IndexPath(item: index, section: 0), at: .centeredVertically, animated: false)//이 코드가 아니라 scrollToItem(at:Indexpath(index:index),at: .left....) 이거로 하면안된다. 위의 것은 된다.
    }
}
// MARK: - UIAnimatable
extension StudianTodayViewController : UIAnimatable {
}

