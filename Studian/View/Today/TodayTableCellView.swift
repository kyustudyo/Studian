//
//  TodayTableCellView.swift
//  Studian
//
//  Created by 이한규 on 2021/10/25.
//

import UIKit
protocol TableCellChangeDelegate: class {
    func tableCellChange(_ todo : Todo)
}

protocol TableViewCenterDelegate : class {
    func setViewCenter()
}
protocol TableViewCheckBoxDelegate : AnyObject {
    func checkBoxInTableView()
}

class TodayTableCell : UITableViewCell {
    
    // MARK: - Properties
    
    weak var centerDelegate :TableViewCenterDelegate?
    weak var delegate: TableCellChangeDelegate?
    var toDoViewModel: ToDoViewModel? {
        didSet {
            update()
        }
    }
    var deleteButtonTapHandler: (()->Void)?
    var isInEditingMode : Bool = false{
        didSet {
            checkButton?.isHidden = isInEditingMode
            removeButton?.isHidden = !isInEditingMode
            guard let btn = contentView.viewWithTag(1) as? UIButton else {return}
            btn.isEnabled = !isInEditingMode
            btn.isUserInteractionEnabled = !isInEditingMode
            todoName.isUserInteractionEnabled = isInEditingMode
            todoDetail.isUserInteractionEnabled = isInEditingMode
        }
    }
    
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
    
    
    
    
    // MARK: - Helpers
    
    func update(){
        backgroundColor = UIColor.white
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 0.5
        layer.cornerRadius = 10
        clipsToBounds = true
        
        guard let toDoViewModel = toDoViewModel else {return}
        todoName.text = toDoViewModel.toDoName
        todoDetail.text = toDoViewModel.toDoDetail
        checkButton?.tintColor = toDoViewModel.doOrNotColor
    
    }
    
    @IBAction func removeTableCell(_ sender: Any) {
        deleteButtonTapHandler?()
    }
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

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {//완료 누를 때.
            textField.resignFirstResponder()
            return true
        }
    
}

