//
//  TodayCellView.swift
//  Studian
//
//  Created by 이한규 on 2021/10/23.
//
import Foundation
import UIKit
import RxSwift
import RxCocoa

protocol GoToDetailDelegate : AnyObject {
    func gotoDetailVC(image:UIImage,index:Int)
}

class TodayCellView :
    UICollectionViewCell{
   
    
    private let imageAndIndexSubject = PublishSubject<(UIImage,Int)>()
    var imageAndIndex: Observable<(UIImage,Int)> {
        return imageAndIndexSubject.asObservable()
    }
    
    var deleteButtonTapHandler: (() -> Void)?
    var indexRow : Int? {
        didSet{
            //짝수 셀 만. 아니면 updateUI에서 걸리므로.
            if indexRow! % 2 == 0{
                today = viewModel.todays[indexRow ?? 0]
                image = viewModel.images[indexRow ?? 0]
                updateUI()
            }
        }
    }
    
    private var viewModel = TodayViewModel()
    private var today : Today?
    private var image : UIImage?
    var selectedRows = [IndexPath]()
    var isInEditingMode: Bool = false {
        didSet {
            removeBtn.isHidden = !isInEditingMode//collection
            tv?.reloadData() // edit 눌렀을때 삭제 모양 나오게하기위해.
        }
    }
    
    @IBOutlet weak var removeBtn: UIButton!
    @IBOutlet weak var tv: UITableView?
    @IBOutlet weak var TodayImg : UIImageView!
    @IBOutlet weak var plusBtn: UIButton!
    
    @IBOutlet weak var cellBackButton: UIButton!
    
    private let disposeBag = DisposeBag()
    private let checkIntRowSubject = PublishSubject<Int>()
    var checkIntRowObservable : Observable<Int> {
        return checkIntRowSubject.asObservable()
    }
    
    var isExtended: Bool = false
    
    //MARK: - Helpers
    
    @IBAction func cellBack(_ sender: UIButton) {
//        cellBackButton.layer.opacity = 0
        
        checkIntRowSubject.onNext(indexRow ?? 0)
        
    }
    
    func plusButtonHidden(){//6개 까지만 추가가능.
        guard let today = today else {return}
        if isInEditingMode {
            if viewModel.getNumberOfTodos(today: today) > 10 {
                plusBtn.isHidden = true
            }
            else {plusBtn.isHidden = false}
        }
        else {
            plusBtn.isHidden = true
        }
    }

    @objc func touchToPickPhoto(image:UIImage) {
        guard let today = today else {
            return
        }
        
        let index = viewModel.getIndex(today: today)
        imageAndIndexSubject.onNext((image,index))
//        goToDetailDelegate?.gotoDetailVC(image:image,index: index)
    }

    func updateUI(){
        guard let image = image, let today = today else {return}
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(touchToPickPhoto))
        TodayImg.addGestureRecognizer(tapGesture)
        TodayImg.isUserInteractionEnabled = true
        TodayImg.layer.cornerRadius = 10
        TodayImg.image = image.fixOrientation()
        tv?.separatorColor = UIColor.clear
        selectedRows = viewModel.getIndexesOfDoSelect(today: today)
    }
    
    @objc func checkBox(_ sender: UIButton){
        
        sender.isSelected = !sender.isSelected
        guard let tv = tv, let today = today else {return}
        let point = sender.convert(CGPoint.zero, to: tv)
        guard let indxPath = tv.indexPathForRow(at: point) else {return}
        print("before check box:", isExtended)
        if isExtended == true{
            isExtended = false
            let todo = viewModel.getTodo(today: today, index: indxPath.row)
            if selectedRows.contains(indxPath) {//green
                guard let index = selectedRows.firstIndex(of: indxPath) else { return }
                selectedRows.remove(at: index)
                viewModel.updateTodo(today: today, todo: Todo(id: todo.id, todoName: todo.todoName, todoDetail: todo.todoDetail, doOrNot: false))
            }
            else {//red
                selectedRows.append(indxPath)
                viewModel.updateTodo(today: today, todo: Todo(id: todo.id, todoName: todo.todoName, todoDetail: todo.todoDetail, doOrNot: true))
            }
            
            print(isExtended)
            tv.reloadRows(at: [indxPath], with: .automatic)
        }
        
        
        checkIntRowSubject.onNext(indexRow ?? 0)
        
    }
    
    @IBAction func removeCell(_ sender: UIButton) {
        deleteButtonTapHandler?()
    }
    
    // MARK: - plusTableCell
    @IBAction func plusTableCell(_ sender: Any) {
        guard let today = today else {return}
        viewModel.createTableCell(today: today)
        guard let nextId = TodayManager.tableCellLastIdDict[today.id] else {return}
        let todo = Todo(id: nextId, todoName: "one", todoDetail: "two",doOrNot: false)
        viewModel.updateTodate(today: today, todo: todo)//추가
        tv?.reloadData()//추가했으므로.
        let index = viewModel.getIndex(today: today)
        let countN = (viewModel.todays[index].todos.count )
        let endIndex = IndexPath(row: countN-2,section:  0 )//더하면 맨 아래로
        self.tv?.scrollToRow(at: endIndex, at: .top, animated: true)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension TodayCellView : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        plusButtonHidden()//reload할때마다 또는 todo개수가 0 개일때도 호출되도록.
        guard let today = today else {return 0}
        let number = viewModel.getNumberOfTodos(today: today)
        return number
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //return UITableViewCell()
        if indexPath.row % 2 == 0 {
            let index = indexPath.row
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TodayTableCell", for: indexPath) as? TodayTableCell else {return UITableViewCell()}
            cell.isInEditingMode = isInEditingMode
            cell.deleteButtonTapHandler = {//@@
                guard let today = self.today else {return}
                let todayIndex = self.viewModel.getIndex(today: today)
                
                self.selectedRows.removeAll {$0 == IndexPath(indexes: [0,indexPath.row])}
                self.viewModel.deleteTodo(today: today,
                                          todo: (self.viewModel.todays[todayIndex].todos[index]))
                self.tv?.reloadData()
                if indexPath.row > 0 {//아래쪽에 있다면 지우면 올라오도록.
                    let endIndex = IndexPath(row: indexPath.row - 2 ,section:  0 )//더하면 맨 아래로
                    self.tv?.scrollToRow(at: endIndex, at: .top, animated: true)
                }
            }
            guard let today = today  else {return UITableViewCell()}
            let todo = viewModel.getTodo(today: today, index: index)

            if let bigBtn = cell.contentView.viewWithTag(1) as? UIButton {
                bigBtn.addTarget(self, action: #selector(checkBox(_:)),for: .touchUpInside)
            }
            cell.indexRow = indexRow
            cell.toDoViewModel = ToDoViewModel(toDo: todo)
            cell.delegate = self
            return cell
        }
        
        else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TodayTableCell2", for: indexPath) as? TodayTableCell else {return UITableViewCell()}
            cell.selectionStyle = .none
            cell.accessoryView?.isHidden = true
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row % 2 == 0 {
            return 60
        }
        else {
            return 5
        }
    }
}

// MARK: - TableCellChangeDelegate

extension TodayCellView : TableCellChangeDelegate {
    func tableCellChange(_ todo:Todo) {
        guard let today = today else {return}
        viewModel.updateTodo(today: today, todo: todo)
        tv?.reloadData()//table cell에 새로운 todo viewmodel을 넣어주기 위함.
    }
}

