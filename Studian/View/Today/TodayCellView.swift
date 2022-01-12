//
//  TodayCellView.swift
//  Studian
//
//  Created by 이한규 on 2021/10/23.
//
//  MainPageTableCell.swift
//  Studian
//
//  Created by 이한규 on 2021/10/22.
//

import Foundation
import UIKit
//collectionview
protocol TodayCellCenterDelegate : class {
    func doCollectionViewCenter(index  :Int)
}
protocol GoToDetailDelegate : class {
    func gotoDetailVC(image:UIImage,index:Int)
}

class TodayCellView :
    UICollectionViewCell{

    @IBOutlet weak var plusBtn: UIButton!
    
    weak var todayCellCenterDelegate : TodayCellCenterDelegate?
    weak var goToDetailDelegate : GoToDetailDelegate?
    @IBOutlet weak var removeBtn: UIButton!
    var deleteButtonTapHandler: (() -> Void)?

    var indexRow : Int? {
        didSet{
            today = viewModel.todays[indexRow ?? 0]
            image = viewModel.images[indexRow ?? 0]
            updateUI()
        }
    }
    
    private var viewModel = TodayViewModel()
    private var today : Today?
    private var image : UIImage?
    
    @IBAction func removeCell(_ sender: UIButton) {
        deleteButtonTapHandler?()
    }
    
    @IBAction func plusTableCell(_ sender: Any) {
        print("click")
        guard let today = today else {return}
        print("in")
        TodayManager.shared.createTableCell(today: today)//index 올림
    
        guard let nextId = TodayManager.tableCellLastIdDict[today.id] else {return}
        
       
        let todo = Todo(id: nextId, todoName: "one", todoDetail: "two",doOrNot: false)
        viewModel.updateTodate(today: today, todo: todo)//추가
        //self.today = today
        
        let index = viewModel.getIndex(today: today)

//        print(viewModel.todays)
//        print("sel row",selectedRows)
        //print("today:",today)
        tv?.reloadData()
        let countN = (viewModel.todays[index].todos.count )
//        print("co:", countN)
        let endIndex = IndexPath(row: countN-2,section:  0 )//더하면 맨 아래로
        self.tv?.scrollToRow(at: endIndex, at: .top, animated: true)
        plusButtonHidden()
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
    
    var isInEditingMode: Bool = false {
        didSet {
            removeBtn.isHidden = !isInEditingMode//collection view의 리무브버튼
            plusButtonHidden()//collection view plus button 확인
            tv?.reloadData() // edit 눌렀을때 삭제 모양 나오게하기위해.

        }
    }
    
    @IBOutlet weak var tv: UITableView?

    @IBOutlet weak var TodayImg : UIImageView!
    
    var selectedRows = [IndexPath]()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){ self.endEditing(true) }

    @objc func touchToPickPhoto(image:UIImage,index:Int) {
        guard let today = today else {
            return
        }
        let index = viewModel.getIndex(today: today)
        goToDetailDelegate?.gotoDetailVC(image:image,index: index)
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
        plusButtonHidden()
    }
    
    //MARK: - Helpers
        
        @objc func checkBox(_ sender: UIButton){
            sender.isSelected = !sender.isSelected
            guard let tv = tv, let today = today else {return}
            let point = sender.convert(CGPoint.zero, to: tv)
            guard let indxPath = tv.indexPathForRow(at: point) else {return}//거기에 해당하는 인덱스패스
            let todo = viewModel.getTodo(today: today, index: indxPath.row)
            if selectedRows.contains(indxPath) {//그린 이야?
                guard let index = selectedRows.firstIndex(of: indxPath) else { return }
                selectedRows.remove(at: index)
                viewModel.updateTodo(today: today, todo: Todo(id: todo.id, todoName: todo.todoName, todoDetail: todo.todoDetail, doOrNot: false))
            }
            else {//빨강 이야?
                selectedRows.append(indxPath)
                viewModel.updateTodo(today: today, todo: Todo(id: todo.id, todoName: todo.todoName, todoDetail: todo.todoDetail, doOrNot: true))
            }
            tv.reloadRows(at: [indxPath], with: .automatic)
        }
    
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension TodayCellView : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
            cell.centerDelegate = self
            
            cell.deleteButtonTapHandler = {//@@
                guard let today = self.today else {return}
                let todayIndex = self.viewModel.getIndex(today: today)
                
                self.selectedRows.removeAll {$0 == IndexPath(indexes: [0,indexPath.row])}
                self.viewModel.deleteTodo(today: today,
                                          todo: (self.viewModel.todays[todayIndex].todos[index]))
                self.plusButtonHidden()
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
            return 10
        }
    }
    
    
    

    
}
// MARK: - TableViewCenterDelegate

extension TodayCellView : TableViewCenterDelegate {
    func setViewCenter() {
        self.todayCellCenterDelegate?.doCollectionViewCenter(index: indexRow ?? 0)
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

