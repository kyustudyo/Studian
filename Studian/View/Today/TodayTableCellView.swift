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
    var yPosition : Int?
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
        
        
        //configureNotificationObservers()
//        if checkButton?.state == .selected {
//            checkButton?.tintColor = .blue
//        }
//        else {
//            checkButton?.tintColor = .purple
//        }
        
        //checkButton?.setBackgroundColor(.blue, for: .selected)
        //checkButton?.setTitleColor(.red, for: .selected)
        //checkButton?.setBackgroundColor(.red, for: .selected)
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
        
        //addGestureRecognizer(tap)
        
        
        //todoName.clearButtonMode = .whileEditing
        //todoName.clearButtonMode = .whileEditing
        
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)

//        let matrix = CGAffineTransform(a: 1,
//                                       b: 0,
//                                       c: CGFloat(tanf(12 * 3.141592653589793 / 180 )),
//                                       d: 1,
//                                       tx: 0,
//                                       ty: 0)
//        let desc = UIFontDescriptor.init(name: "AppleSDGothicNeo-Thin",
//                                                matrix: matrix)
//        todoName.font = UIFont(descriptor: desc, size: 17)
                
    }
//    let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
    
    
//    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
//        print("okokok")
//        // handling code
//    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        centerDelegate?.setViewCenter()
//        guard let yPosition = yPosition else {
//            return
//        }
//        guard let superviewParrent = superview?.superview?.superview?.superview else {print("df")
//            return
//        }
//        guard let superview = superview?.superview?.superview else {print("ㅠㅠ")
//            return
//        }
//        pastViewCenter = superview.center.y
////        superview.center = superviewParrent.center
//        superviewParrent.center.y = superviewParrent.center.y - CGFloat(200)
        
        //                return
        //            }
        //print("textfield!!\(yPosition)")
        //TodayManager.yPosition = yPosition
//        childView.centerYAnchor.constraint(equalTo: parentView.centerYAnchor).isActive = true
//        if yPosition ?? 330 > Int(UIScreen.main.bounds.height / 2) {
//            keyboardWillShowAbig()
//        }
//        if yPosition ?? 400 > Int(UIScreen.main.bounds.height-250) {
//            guard let superview = superview?.superview?.superview?.superview else {print("ㅠㅠ")
//                return
//            }
//            superview.frame.origin.y = -250
//            print("idid")
//            
//        }
//        else {print("what")}
//        
        
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        //handleTap()
//        if yPosition ?? 400 > Int(UIScreen.main.bounds.height-250) {
//            superview?.superview?.superview?.superview?.frame.origin.y = 0
//
//        }
//        guard let superviewParrent = superview?.superview?.superview?.superview else {print("df")
//            return
//        }
//        guard let superview = superview?.superview?.superview else {print("ㅠㅠ")
//            return
//        }
//        guard let pastViewCenter = pastViewCenter else {
//            return
//        }
//
//        superviewParrent.center.y = pastViewCenter
        
    }

//    func keyboardWillShowAbig(){
//        superview?.superview?.superview?.superview?.frame.origin.y = -(200)
//    }
    
//    func keyboardWillHide(){
//        superview?.superview?.superview?.superview?.frame.origin.y = 0
//    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
        }

//    @objc
//    @objc func keyboardWillShow(_ sender: Notification) {//이리저리 가서 힘들게함.
//
//        //if yPosition ?? 330 > Int(UIScreen.main.bounds.height / 2) {
//        print("yp" ,yPosition ?? 400)
//        if yPosition ?? 400 > Int(UIScreen.main.bounds.height-250) {
//            superview?.superview?.superview?.superview?.frame.origin.y = -250
//        }
//                //}
//
//        //print("yposition:" ,todo?.todoName,yPosition)
//        //print(UIScreen.main.bounds.height)
////        keyboardWillShowAbig()
////        if let keyboardFrame: NSValue = sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue { let keyboardRectangle = keyboardFrame.cgRectValue
////        let keyboardHeight = keyboardRectangle.height
////        print("keyboardHeight = \(keyboardHeight)")
//
//        //}
//    }
//
////        if yPosition > Int(UIScreen.main.bounds.height/3) ?? 200{
////            superview?.superview?.superview?.superview?.frame.origin.y = -150 // Move view 150 points upward
////        }
//
//        //uperview?.superview?.superview?.superview?.frame.origin.y = -150 // Move view 150 points upward
//
//
//        }

//     @objc
//        func keyboardWillHide(_ sender: Notification) {
//            //superview?.superview?.superview?.superview?.frame.origin.y = 0
//            if yPosition ?? 400 > Int(UIScreen.main.bounds.height-250) {
//                superview?.superview?.superview?.superview?.frame.origin.y = 250
//
//            }
////            guard let yPosition = yPosition else {
////                return
////            }
////            if yPosition > Int(UIScreen.main.bounds.height/3) ?? 200 {
////                superview?.superview?.superview?.superview?.frame.origin.y = 0 // Move view to original position
////            }
//        }
            
//
//
//            //superview?.superview?.superview?.superview?.frame.origin.y = 0 // Move view to original position
//        }
    
    
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
//    override func layoutSubviews() {
//        super.layoutSubviews()
////        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
//    }
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
    
//    @objc func keyboardWillShow() {
//        if view.frame.origin.y == 0{
//            self.view.frame.origin.y -= 88 //88픽셀 올려라.화면이 올라가서 텍스트 가 좀 보이도록.
//        }
//    }
//    @objc func keyboardWillHide() {
//        if view.frame.origin.y != 0{
//            self.view.frame.origin.y = 0 //88픽셀 올려라.
//        }
//    }
    
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
    
//    @objc func textDidChange(sender: UITextField){
//        print("clcl")
//        let newTodo : Todo?
//        if sender == todoName {
//            todo?.update(todoName: sender.text ?? "", todoDetail: todoDetail.text ?? "")
////            purpose = Purpose(id: -1, name: sender.text!, oneSenetence: SecondTextField.text!)//이렇게 안하고 아래처럼하면 누를때마다 id 올라간다.
////            purpose = PurposeManager.shared.createPurpose(name: sender.text, oneSentence: FirstTextField.text)
//            //viewModel?.textFieldText1 = sender.text
//            //print("\(viewModel?.)")
//        }
//        else if sender == todoDetail {
//            todo?.update(todoName: todoName.text ?? "", todoDetail: sender.text ?? "")
////            purpose = Purpose(id: -1, name: FirstTextField.text!, oneSenetence: sender.text!)
////            purpose = PurposeManager.shared.createPurpose(name: SecondTextField.text, oneSentence: sender.text)
//        }
//        print(todo)
//        guard let todo = todo else {return}
//        
//        delegate?.tableCellChange(todo)
////        viewModel?.addPurpose(purpose)
////        delegate?.completeTwoTexts(vm: viewModel!)
//        //checkFormStatus()
//        
//    }
    


}

