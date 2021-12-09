//
//  PurposeHeaderView.swift
//  Studian
//
//  Created by 이한규 on 2021/10/22.
//

import UIKit
class PurposeHeaderView : UICollectionReusableView {
    @IBOutlet weak var purposeImageView: UIImageView?
    @IBOutlet weak var purposeName: UILabel?
    @IBOutlet weak var Onesentence: UILabel?
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var profilePlusButton: UIButton!
    @IBOutlet weak var TextPlusButton: UIButton!
    
    var headerModel : HeaderModel?
    var tapHandler: ((HeaderModel)->Void)?
    var editMode : Bool = false {//edit 누를 때만 텍스트뷰 수정 가능.
        didSet {
            
            
            textView.isEditable = false
//            textView.isEditable = editMode//edit누르면 수정가능
            
            
            
            //profilePlusButton.isHidden = !editMode
            //위 코드는 원래 수정 눌러야만 바꿀 수 있었다.
            
            
            
            print("header editmode:\(editMode)")
//            TextPlusButton.isHidden = !editMode
            //위 코드는 원래 수정 눌러야만 바꿀 수 있었다.
        }
    }
//    func textViewSave(){
//        guard let textViewContents = textView.text, textViewContents.isEmpty == false else {return }
//        saveFile(text: textViewContents)
//    }
    func configure(img:UIImage){
        purposeImageView?.image = img
    }
    
    func configure2(data: Data){
        purposeImageView?.image = UIImage(data: data)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //commonInit()
        purposeImageView?.layer.cornerRadius = 20
        purposeName?.textColor = UIColor.white
        Onesentence?.textColor = UIColor.systemGray2
    }
    
    
        
    func updateForMainPage(){
        //self.purpose = purpose//없애야할듯.
        let PurposePicture:UIImage? = ImageFileManager.loadImageFromDocumentDirectory(fileName: "PurposePicture.png",completion: {_ in
            print("hi")
        }) ?? UIImage(systemName: "photo.fill")
        self.purposeImageView?.image = PurposePicture
        //self.purposeImageView.rotate
        
        
        purposeImageView?.layer.cornerRadius = 20
//        self.purposeName?.text = purpose.name
//        self.Onesentence?.text = purpose.oneSenetence
        
        
    }
    
    
    func updateForTodayPage(){
        purposeImageView?.layer.cornerRadius = 20
    }
    
    
    
    
    
    @IBAction func Tapped(_ sender: UIButton) {
        guard let headerModel = self.headerModel else{return}
        tapHandler?(headerModel)
    }
    
}

