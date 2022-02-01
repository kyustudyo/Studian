//
//  StudianTodayViewController.swift
//  Studian
//
//  Created by 이한규 on 2021/10/24.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

private let TodayCell = "TodayCell"
private let TodayCell2 = "TodayCell2"
private let todayDetailVC = "todayDetailViewController"
class StudianTodayViewController: UIViewController {
    
    // MARK: - Properties
    let disposeBag = DisposeBag()
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var plusCellsBtn: UIButton!
    private let todayViewModel = TodayViewModel()
    var selectedInt:Set<Int> = []
    @IBOutlet var collectionview: UICollectionView!
    lazy private var todayCellSizeViewModel = TodayCellSizeViewModel(width: collectionview.bounds.width - 20 * 2)
    
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
 
    
    func prepareDarkMode() {
        editButton.setTitleColor(DefaultStyle.Colors.tint, for: .normal)//dark mode
        saveButton.setTitleColor(DefaultStyle.Colors.tint, for: .normal)//dark mode
    }
    
    func configureUI(){
        collectionview.alwaysBounceVertical = true
        self.navigationController?.navigationItem.largeTitleDisplayMode = .always
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        startIndicator()//custom
        prepareDarkMode()
        editButtonHidden()//많으면 추가 못하게.
        configureUI()
        collectionview.contentInset = .init(top: 0, left: 0, bottom: 300, right: 0)
        todayViewModel.loadPurposes(completion:
                                        { [weak self] in
            guard let this = self else {return}
            this.navigationController?.navigationBar.topItem?.title = "Today..."
            this.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: this.saveButton )
            this.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: this.editButton )
            
            this.stopIndicator()
            this.collectionview.reloadData()})
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("setCenterView"), object: nil, queue: .main, using: {(noti) in
            if let int = noti.userInfo?["setCenterView"] as? Int{
                print("on")
                self.collectionview.scrollToItem(at:IndexPath(item: int, section: 0), at: .centeredVertically, animated: true)
            }
            
        })
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
            cell.isExtended = selectedInt.contains(indexPath.row)//fold 했을 때 적용위해.
            let today = todayViewModel.todays[indexPath.row]
            cell.indexRow = indexPath.row
            cell.imageAndIndex.subscribe(onNext:{ [weak self] in
                let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                guard let detailVC = storyboard.instantiateViewController(withIdentifier: todayDetailVC) as? todayDetailViewController else {return}//스토리보드에서 연결 안해도 이거면 갈 수 있다.
                detailVC.image = self?.todayViewModel.images[$0.1]
                detailVC.index = $0.1
                detailVC.imageAndIndex
                    .subscribe(onNext:{ [weak self] in
                        self?.showLoadingAnimation()
                        self?.todayViewModel.editToday(image: $0.0, index: $0.1){ [weak self] in
                            self?.reloadCell()
                            self?.hideLoadingAnimation()
                        }
                    }).disposed(by: self?.disposeBag ?? DisposeBag())
                
                detailVC.modalPresentationStyle = .overFullScreen
                self?.present(detailVC, animated: true, completion: nil)

            }).disposed(by: disposeBag)

            cell.deleteButtonTapHandler = {
                self.todayViewModel.deleteToday(today)
                self.todayViewModel.deleteImage(index: indexPath.row)
                self.editButtonHidden()
                self.collectionview.reloadData()
            }
            cell.isInEditingMode = isEditing
            cell.checkIntRowObservable.subscribe(onNext:{ int in

                self.selectedInt.insert(int)
                cell.isExtended = self.selectedInt.contains(int) ? true : false
                
                print("cell isExtended:",cell.isExtended)
                
                collectionView.collectionViewLayout.invalidateLayout()
            }).disposed(by: disposeBag)
            return cell
        }
        else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TodayCell2, for: indexPath) as? TodayCellView else {return UICollectionViewCell()}
            cell.indexRow = indexPath.row
            cell.checkIntRowObservable.subscribe(onNext:{ int in
                print(int)
                self.selectedInt = self.selectedInt.filter{$0 != (int-1) }
                
                print(self.selectedInt)
                collectionView.reloadData()
//                collectionView.collectionViewLayout.invalidateLayout()
            }).disposed(by: disposeBag)
            
            return cell
        }
    }
}

extension StudianTodayViewController : UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    @IBAction func plusCells(_ sender: UIButton) {
        
        showLoadingAnimation()
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: hideLoadingAnimation)
        
    }

    func editButtonHidden() {

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
            
            var newImage = UIImage()
            if let possibleImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
                newImage = possibleImage.fixOrientation()
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


extension StudianTodayViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        self.todayCellSizeViewModel.indexPathRow = indexPath.row
        self.todayCellSizeViewModel.selectedInt = self.selectedInt
        self.todayCellSizeViewModel.countOfToday = self.todayViewModel.todays.count
        return todayCellSizeViewModel.cellSize
        
    }
}



// MARK: - UIAnimatable
extension StudianTodayViewController : UIAnimatable {
}

