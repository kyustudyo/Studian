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

class TodayTableCell : UITableViewCell,UITextFieldDelegate {
    
//    @IBOutlet weak var todayDo: UILabel!
//    @IBOutlet weak var todayDoDetail: UILabel!
    @IBOutlet weak var checkButton : UIButton?
    @IBOutlet weak var removeButton: UIButton?
    @IBOutlet weak var todoName: UITextField!
    @IBOutlet weak var todoDetail: UITextField!
    weak var centerDelegate :TableViewCenterDelegate?
    weak var delegate:TableCellDelegate?
//    var yPosition : Int?
    var pastViewCenter : CGFloat?
    var todo : Todo?
    var deleteButtonTapHandler: (()->Void)?
//    var topInset: CGFloat = 0
//    var leftInset: CGFloat = 0
//    var bottomInset: CGFloat = 0
//    var rightInset: CGFloat = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //checkButton?.setImage(UIImage(named: "checkmark.seal"), for: .selected)
        checkButton?.setTitle("", for: .normal)
        removeButton?.setTitle("", for: .normal)
        
        
    }
    func update(todo : Todo){
        todoName.text = todo.todoName
        todoDetail.text = todo.todoDetail
        todoName.borderStyle = .none
        todoDetail.borderStyle = .none
        todoName.textColor = .black
        todoDetail.textColor = .black
        print("todo:", todo.doOrNot)
        checkButton?.tintColor = todo.doOrNot ? .green : .red
        configureNotificationObservers()
        todoName.delegate = self
        todoDetail.delegate = self
        todoName.addDoneButtonOnKeyboard()
        todoDetail.addDoneButtonOnKeyboard()
        todoName.delegate = self
        todoDetail.delegate = self
        

                
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        centerDelegate?.setViewCenter()
    }
    func textFieldDidEndEditing(_ textField: UITextField) {

        
    }


    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
        }


    
    @IBAction func removeTableCell(_ sender: Any) {
        
        deleteButtonTapHandler?()
    }
    
    override func layoutMarginsDidChange() {
        super.layoutMarginsDidChange()
//        self.layoutMargins = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5))
        
//        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
    }

}
extension TodayTableCell {
    func configureNotificationObservers(){
        
        //todoName.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        //todoDetail.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        todoName.addTarget(self, action: #selector(textDidEnd), for: .editingDidEnd)
        todoDetail.addTarget(self, action: #selector(textDidEnd), for: .editingDidEnd)
//        todoName.isUserInteractionEnabled = true
//        todoDetail.isUserInteractionEnabled = true
        
        

    }

    @objc func textDidEnd(sender:UITextField){
        print("clcl")
//        if yPosition ?? 200 > Int(UIScreen.main.bounds.height / 3) {
//            keyboardWillHide()
//        }
        let newTodo : Todo?
        if sender == todoName {
            todo?.update(todoName: sender.text ?? "", todoDetail: todoDetail.text ?? "",doOrNot: false)
//            purpose = Purpose(id: -1, name: sender.text!, oneSenetence: SecondTextField.text!)//이렇게 안하고 아래처럼하면 누를때마다 id 올라간다.
//            purpose = PurposeManager.shared.createPurpose(name: sender.text, oneSentence: FirstTextField.text)
            //viewModel?.textFieldText1 = sender.text
            //print("\(viewModel?.)")
        }
        else if sender == todoDetail {
            todo?.update(todoName: todoName.text ?? "", todoDetail: sender.text ?? "",doOrNot: false)
//            purpose = Purpose(id: -1, name: FirstTextField.text!, oneSenetence: sender.text!)
//            purpose = PurposeManager.shared.createPurpose(name: SecondTextField.text, oneSentence: sender.text)
        }
        print(todo)
        guard let todo = todo else {return}
        
        delegate?.tableCellChange(todo)
//        viewModel?.addPurpose(purpose)
//        delegate?.completeTwoTexts(vm: viewModel!)
        //checkFormStatus()
        
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
      print("textFieldShouldBeginEditing:")
      return true
      }


}

