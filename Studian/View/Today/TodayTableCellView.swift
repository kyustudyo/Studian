//
//  TodayTableCellView.swift
//  Studian
//
//  Created by 이한규 on 2021/10/25.
//

import UIKit
protocol TableCellDelegate: class {
    func tableCellChange(_ todo : Todo)
}

protocol TableViewCenterDelegate : class {
    func setViewCenter()
}

class TodayTableCell : UITableViewCell {
    
//    @IBOutlet weak var todayDo: UILabel!
//    @IBOutlet weak var todayDoDetail: UILabel!
    @IBOutlet weak var checkButton : UIButton? 
    @IBOutlet weak var removeButton: UIButton?
    @IBOutlet weak var todoName: UITextField! {
        didSet {
            todoName.getCustomTextFieldSetting()
            todoName.delegate = self//notification달기위해.
            
        }
    }
    @IBOutlet weak var todoDetail: UITextField! {
        didSet {
            todoDetail.getCustomTextFieldSetting()
            todoDetail.delegate = self
        }
    }
    weak var centerDelegate :TableViewCenterDelegate?
    weak var delegate: TableCellDelegate?
    var toDoViewModel: ToDoViewModel? {
        didSet {
            update()
        }
    }
    var deleteButtonTapHandler: (()->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //checkButton?.setImage(UIImage(named: "checkmark.seal"), for: .selected)
        checkButton?.setTitle("", for: .normal)
        removeButton?.setTitle("", for: .normal)
    }
    
    func update(){
        guard let toDoViewModel = toDoViewModel else {return}
        todoName.text = toDoViewModel.toDoName
        todoDetail.text = toDoViewModel.toDoDetail
        checkButton?.tintColor = toDoViewModel.doOrNotColor
    }

    


    
    @IBAction func removeTableCell(_ sender: Any) {
        deleteButtonTapHandler?()
    }
    
//    override func layoutMarginsDidChange() {
//        super.layoutMarginsDidChange()
////        self.layoutMargins = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
//    }
//
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5))
//
//    }
}

// MARK: - UITextFieldDelegate

extension TodayTableCell : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        centerDelegate?.setViewCenter()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let viewModel = toDoViewModel,
                let delegate = delegate else {return}
        var todo = viewModel.toDo
        let text = textField.text ?? ""
        
        if textField == todoName {
            todo = viewModel.configureToDo(toDo: todo,
                                    text: text, textKinds: .toDoName)
            
        }
        else if textField == todoDetail {
            todo = viewModel.configureToDo(toDo: todo, text: text, textKinds: .toDoDetail)
        }
        
        delegate.tableCellChange(todo)
    }


    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
        }
    
//    func configureNotificationObservers(){
//        todoName.addTarget(self,
//                           action: #selector(textDidEnd),
//                           for: .editingDidEnd)
//        todoDetail.addTarget(self,
//                             action: #selector(textDidEnd),
//                             for: .editingDidEnd)
//    }
    
    
//    @objc func textDidEnd(sender:UITextField){
//        if sender == todoName {
//            todo?.update(todoName: sender.text ?? "",
//                         todoDetail: todoDetail.text ?? "",
//                         doOrNot: false)
//        }
//        else if sender == todoDetail {
//            todo?.update(todoName: todoName.text ?? "",
//                         todoDetail: sender.text ?? "",
//                         doOrNot: false)
//        }
//        guard let todo = todo else {return}
//
//        delegate?.tableCellChange(todo)
//    }
//    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//      print("textFieldShouldBeginEditing:")
//      return true
//      }


}

