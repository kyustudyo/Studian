//
//  MainPageTableCell.swift
//  Studian
//
//  Created by 이한규 on 2021/10/22.
//

import Foundation
import UIKit

class PurposeCellView : UICollectionViewCell{
    @IBOutlet weak var purposeImageView: UIImageView!
    @IBOutlet weak var purposeName: UILabel!
    @IBOutlet weak var Onesentence: UILabel!
    @IBOutlet weak var deleteCellBtn: UIButton!
    var deleteButtonTapHandler: (() -> Void)?
    var isInEditingMode: Bool = false {
        didSet {
            print("!isin = : \(!isInEditingMode) 따라서 checkmark.ishhidden도.")
            deleteCellBtn?.isHidden = !isInEditingMode

        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        buttonCustom()
        purposeImageView?.layer.cornerRadius = 20
        
    }
    @IBAction func deleteCell(_ sender: UIButton) {
        print("delete!")
        deleteButtonTapHandler?()
    }
    func buttonCustom(){
        deleteCellBtn.tintColor = .black
        
    }
    func updateUI(purpose: Purpose?,image: UIImage?){
        print(image?.description)
        purposeImageView.image = image
        purposeImageView?.layer.cornerRadius = 10
        purposeName.text = purpose?.name
        Onesentence.text = purpose?.oneSenetence
        //guard let purpose = purpose else{return}
        
        
        //purposeImageView.image = purpose.
        //purposeName.text = purpose.name
        //Onesentence.text = purpose.oneSenetence
    }
}
