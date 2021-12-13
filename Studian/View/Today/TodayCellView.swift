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
protocol tmpDelegate : class {
    func connectPlz(index  :Int)
}
protocol goToDetailDelegate : class {
    func gotoDetailVC(image:UIImage,index:Int)
}
class TodayCellView :
    UICollectionViewCell, TableViewCenterDelegate{
    func setViewCenter() {
        guard let today = today else{return}
        print("몇번째:",viewModel?.getIndex(today: today))
        let index = viewModel?.getIndex(today: today)
        print("yposition: ",yPosition)
        print("click")
        
        self.tmpDelegate?.connectPlz(index: index ?? 0)
    }
    
    
    
    
    @IBOutlet weak var plusBtn: UIButton!
    
    
    weak var tmpDelegate : tmpDelegate?
    weak var delegate : goToDetailDelegate?
    
    @IBOutlet weak var removeBtn: UIButton!
    var deleteButtonTapHandler: (() -> Void)?
    //@IBOutlet weak var checkMark: UILabel?
    var viewModel : TodayViewModel?
    var today: Today?
    var yPosition : Int?
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
        viewModel?.updateTodate(today: today, todo: todo)//추가
        //self.today = today
        
        guard let index = viewModel?.getIndex(today: today) else {return}
        //print("개수:", (viewModel?.todays[index].todos.count ?? 0) / 2 )
        
        //print("k",countN-1)
        
//        if countN != 0{
//            let endIndex = IndexPath(row: countN - 1 ,section:  0 )
//            self.tv?.scrollToRow(at: endIndex, at: .bottom, animated: true)
//        }
        
        
        
        print(viewModel?.todays)
        print("sel row",selectedRows)
        //print("today:",today)
        tv?.reloadData()
        let countN = (viewModel?.todays[index].todos.count ?? 0)
        print("co:", countN)
        let endIndex = IndexPath(row: countN-2,section:  0 )//더하면 맨 아래로
        self.tv?.scrollToRow(at: endIndex, at: .top, animated: true)
        plusButtonHidden()
    }
    
    func plusButtonHidden(){//6개 까지만 추가가능.
        guard let today = today else {return}
        guard let index = viewModel?.getIndex(today: today) else {return}
        if isInEditingMode {
            if viewModel?.todays[index].todos.count ?? 0 > 10 {
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
            print("!isin = : \(!isInEditingMode) 따라서 checkmark.ishhidden도." )//누르면 이것이 false
            
            //또누르면 true 즉 숨겨라. 숨길때 라벨을 바꾸버리자.
//            plusBtn.isHidden = isInEditingMode
            //print("plus ishidden",plusBtn.isHidden)
            removeBtn.isHidden = !isInEditingMode//collection view의 리무브버튼
            plusButtonHidden()//collection view plus button 확인
            tv?.reloadData() // edit 눌렀을때 삭제 모양 나오게하기위해.
            
            //checkMark?.isHidden = !isInEditingMode
//            if !isInEditingMode {
//                if checkMark
//                checkMark?.text = "ddd"
//
//            }
        }
    }
    
    @IBOutlet weak var tv: UITableView?
    
    //@IBOutlet var chkBox: UIButton!
    

    @IBOutlet weak var TodayImg : UIImageView!
    var selectedRows = [IndexPath]()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){ self.endEditing(true) }

    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //textViewDone()
//        print("isinedit:")
//        print(isInEditingMode)
//        print("checkmark:")
//        print(checkMark?.isHidden)
        //chkBox.setImage(UIImage(named: "checkmark.seal"), for: .normal)
        //checkMark?.isHidden = true

//        tv.separatorColor = UIColor.red
        TodayImg?.layer.cornerRadius = 10
        //tv.separatorInset = .zero
        tv?.separatorColor = UIColor.clear
        //tv?.backgroundColor = .blue
        //tv.tableFooterView = UIView()
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //cell.backgroundColor = .blue
    }
    
    override var isSelected: Bool {
        didSet {
            print("isselected바뀜 현재 isinedit: \(isInEditingMode)")
            if isInEditingMode {
                print("isselected: \(isSelected) isinediting : \(isInEditingMode)")
                //checkMark?.text = isSelected ? "✓" : "○"
            }
//            if !isInEditingMode {
//                if !isSelected{
//                checkMark?.text = "asd"
//                }
//            }
            
            
        }
    }
    @objc func touchToPickPhoto(image:UIImage,index:Int) {
        print("d")
        guard let today = today else {
            return
        }
        guard let index = viewModel?.getIndex(today: today) else {return}
        delegate?.gotoDetailVC(image:image,index: index)
        
    //code
//        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
//                guard let detailVC = storyboard.instantiateViewController(withIdentifier: "PurposeDetailVIewController") as? todayDetailViewController else {return}//스토리보드에서 연결 안해도 이거면 갈 수 있다.
//                //let purposeAndImage = purposeViewModel.purposeAndImage(id: indexPath.item)
//                //detailVC.purposeAndImage = purposeAndImage
//
//
//
//                detailVC.image = todayViewModel.images[indexPath.row]
//        detailVC.image = UIImage(systemName: "circle")
//
//
//
//        //        detailVC.viewModel = purposeViewModel
//        //        detailVC.index = indexPath.item
//        //        detailVC.purpose = purposeViewModel.purposes[indexPath.row]
//                detailVC.delegate = self
//                detailVC.modalPresentationStyle = .overFullScreen//full screen 하면 detailview에서 색깔 십힘
//        //        guard let purpose = purposeViewModel.purposes[indexPath.item]  else {return}
//
//
//                    present(detailVC, animated: true, completion: nil)
//
//
//        //        playerVC.simplePlayer.replaceCurrentItem(with: item)
//        print("rr")
    }
    func updateUI(today:Today,image:UIImage){
        guard let image = UIImage(data: today.imageData) else{
            return
        }
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(touchToPickPhoto))
        TodayImg.addGestureRecognizer(tapGesture)
        TodayImg.isUserInteractionEnabled = true
        TodayImg.image = image.fixOrientation()
        
        print("todos:",today.todos)
        selectedRows = []//그린으로 변화시켜놓은 애를 삭제하면 selectedrows가 한칸 씩 밀리고,
        //에딧버튼에서 나가면 updateUI함수를 호출하므로 새로 selecterows를 만든다.
        for (index,todo) in today.todos.enumerated() {
            if todo.doOrNot {
                let indexPath = IndexPath(indexes: [0,index])
                if !selectedRows.contains(indexPath){
                    selectedRows.append(indexPath)
                }
                
            }
        }
        print("todos,selected rows: ",selectedRows)
        
        plusButtonHidden()
        //TodayName.text = "d"
//        TodayOneSentence.text = "qwq"
//        guard let purpose = purpose else {return}
        //purposeImageView.image = purpose.image
        //purposeName.text = "sdsdsdsd"
        //Onesentence.text = purpose.oneSenetence
        
        //addGestureRecognizer(tap)
        
    }
//    let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
//    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
//        print("okokok")
//        // handling code
//    }
    
    

}

//table
extension TodayCellView : UITableViewDelegate, UITableViewDataSource {
    
    
    
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        //tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        if indexPath.row % 2 == 0 {
//            tableView.cellForRow(at: indexPath)?.accessoryView?.isHidden = false
//        }
//    }
//
//    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
//        if indexPath.row % 2 == 0 {
//            tableView.cellForRow(at: indexPath)?.accessoryView?.isHidden = true
//        }
//
//
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let today = today else {return 0}
        guard let number = viewModel?.getNumberOfTodos(today: today) else{ return 0}
        print("보여줘야할:\(number)")
        return number 
        
    }
    
    //collectionview check box
    @objc func checkBox(_ sender: UIButton){
        
        sender.isSelected = !sender.isSelected
        print("주의1: sender_isselected:\(sender.isSelected)")
        let point = sender.convert(CGPoint.zero, to: tv!)
        let indxPath = tv!.indexPathForRow(at: point)//거기에 해당하는 인덱스패스
        
        
        //tv?.scrollToRow(at: indxPath!, at: .bottom, animated: false)
        
        print("기존 selected:\(selectedRows)")
        print("indexpath:",indxPath!)
        guard let today = today ,let todo = viewModel?.getTodo(today: today, index: indxPath!.row) else {return}
        print("pass?")
        print("통과이후와 indexpath",selectedRows,indxPath)
        
        if selectedRows.contains(indxPath!) {//그린 이야?
            
                       selectedRows.remove(at: selectedRows.index(of: indxPath!)!)
            viewModel?.updateTodo(today: today, todo: Todo(id: todo.id, todoName: todo.todoName, todoDetail: todo.todoDetail, doOrNot: false))
            
        }
        else {//빨강 이야?
                 selectedRows.append(indxPath!)
                viewModel?.updateTodo(today: today, todo: Todo(id: todo.id, todoName: todo.todoName, todoDetail: todo.todoDetail, doOrNot: true))
               }
        
        print(selectedRows)
        print("indexpat\(indxPath!)")//전체 컬렉션뷰가 커지면 체크박스 바뀌는 속도 느려짐.
               tv!.reloadRows(at: [indxPath!], with: .automatic)
    }
    
    //tableview
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //return UITableViewCell()
        if indexPath.row % 2 == 0 {
            let index = indexPath.row
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TodayTableCell", for: indexPath) as? TodayTableCell else {return UITableViewCell()}
            guard let smallBtn = cell.contentView.viewWithTag(2) as? UIButton else { return UITableViewCell()}
            
            //print("sdsds",isInEditingMode)
            
            cell.checkButton?.isHidden = isInEditingMode
            cell.removeButton?.isHidden = !isInEditingMode
//            plusBtn.isHidden = isInEditingMode
            
            cell.centerDelegate = self
            
            cell.deleteButtonTapHandler = {
                print("delete@@@@@@@@@@@@@@@@@@@@@@@@")
                guard let today = self.today else {return}
                let todayIndex = self.viewModel?.getIndex(today: today) ?? 0
                
                
                //print("change:",self.viewModel?.todays)
                print("indexpath:\(indexPath.row)")
                print("todos:",today.todos)
                
                //print("today.todos:\(today.todos)")
                
                
//                let todo = self.viewModel?.getTodo(today: today, index: indexPath.row)
//                let indexpa = IndexPath(index: todo?.id ?? 0)
                print("i want to zegu:",indexPath.row)
                self.selectedRows.removeAll {$0 == IndexPath(indexes: [0,indexPath.row])}
                
                
                
                print(self.viewModel?.todays[todayIndex].todos)
                self.viewModel?.deleteTodo(today: today, todo: (self.viewModel?.todays[todayIndex].todos[index])!)
                print("imdexpath: \(IndexPath(indexes: [0,index]))")
                
                
                print("selsel",self.selectedRows)
                
                print("change:",self.viewModel?.todays)
                self.plusButtonHidden()
                print("kk",indexPath.row)
                
                
                
                self.tv?.reloadData()
                
                
                if indexPath.row > 0 {//아래쪽에 있다면 지우면 올라오도록.
                    //let countN = (self.viewModel?.todays[index].todos.count ?? 0)
                    let endIndex = IndexPath(row: indexPath.row - 2 ,section:  0 )//더하면 맨 아래로
                    self.tv?.scrollToRow(at: endIndex, at: .top, animated: true)
                }
                
                
                
                //@@
                
            }
            //smallBtn.setImage(UIImage(named: "person"), for: .normal)
            //print("df")
            //smallBtn.setTitle("", for: .normal)
            //smallBtn.setImage(UIImage(named: "checkmark.seal"), for: .normal)
//            smallBtn.setImage(UIImage(named : "unselectedImage"), for: .normal)
//            smallBtn.setImage(UIImage(named : "selectedImage"), for: .selected)
//            smallBtn.addTarget(self, action: #selector(checkBox(_:)),for: .touchUpInside)
            guard let today = today ,let todo = viewModel?.getTodo(today: today, index: index) else {return UITableViewCell()}
            print(todo.doOrNot)
                
            //전체 버튼
            //if let today = today {
//                let todos = viewModel?.todays[viewModel?.getIndex(today: today) ?? 0].todos
//                let todo = todos![indexPath.row]
                
                //print("todos:\(todos),index:\(indexPath.row)")
                //print("df")
                
            //}
            
             
            if !isInEditingMode {//edit모드 아닐때만 테이블셀 클릭 시 초록색
                
                if let bigBtn = cell.contentView.viewWithTag(1) as? UIButton {
                    bigBtn.isEnabled = true
                
                    bigBtn.addTarget(self, action: #selector(checkBox(_:)),for: .touchUpInside)
                    //smallBtn.isSelected = false
                    //smallBtn.tintColor = .red
                    
                    
                    
                    
                   
                    //smallBtn.setImage(UIImage(named: "person"), for: .disabled)
                    //if selectedRows.contains(indexPath) {
                        //print("indexpath:",indexPath.row)
                        //print("눌렀네요 selectedRows:",selectedRows)
                        //smallBtn.isSelected = true
                        //smallBtn.tintColor = .red
                        
                        
                        
                        /////////////////////
                        //smallBtn.setImage(UIImage(named: "checkmark.seal"), for: .selected)
                    //}
                    bigBtn.isUserInteractionEnabled = true
                    
                    
                    
                    cell.todoName.isUserInteractionEnabled = false
                    cell.todoDetail.isUserInteractionEnabled = false
                }
            }
            else if isInEditingMode {
                if let bigBtn = cell.contentView.viewWithTag(1) as? UIButton {
                    
                    
                    
                    
                    bigBtn.isUserInteractionEnabled = false
                    bigBtn.isEnabled = false
                    
                    
                    
                    
                    cell.yPosition = self.yPosition
                    print("2번째:",yPosition)
                    
                    cell.todoName.isUserInteractionEnabled = true
                    cell.todoDetail.isUserInteractionEnabled = true
                    
                }
            }
            
            cell.todo = viewModel?.getTodo(today: today, index: index)
            print(todo.doOrNot)
            cell.update(todo: todo)//print todo.bool
            
            //red green 바꾸었으므로 새로운 todo 얻기
            cell.delegate = self
            
            //print("todos",today?.todos)
            //print("index",index)
            
            
           
            
            
//            cell.accessoryView = CheckMarkView.init()
//            cell.accessoryView?.isHidden = true
            
            cell.backgroundColor = UIColor.white
            //cell.layer.masksToBounds = true
            //cell.layer.borderWidth = 100
    //        cell.topInset = 20
    //        cell.bottomInset = 20
            
            cell.layer.borderColor = UIColor.black.cgColor
            cell.layer.borderWidth = 0.5
            cell.layer.cornerRadius = 10
            cell.clipsToBounds = true
            
            return cell
        }
        
        else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TodayTableCell2", for: indexPath) as? TodayTableCell else {return UITableViewCell()}
            cell.selectionStyle = .none
            cell.accessoryView?.isHidden = true
            return cell
        }
        
        
        
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("@@@@indexpath@@@@:\(indexPath.row)")
        //tv?.scrollToRow(at: indexPath, at: .middle, animated: true)
        //print("dodo")
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
extension TodayCellView : TableCellDelegate {
    func tableCellChange(_ todo:Todo) {
        print("ssd")
        guard let today = today else {return}
        viewModel?.updateTodo(today: today, todo: todo)
        //guard let today = today else {return}
        //let todos = viewModel?.todays[viewModel?.getIndex(today: today) ?? 0]
        
    }
    
    
}


