//
//  inputContainerView.swift
//  ChatApp
//
//  Created by 이한규 on 2021/09/10.
//

import UIKit
class InputContainerView: UIView {

//    override init(frame: CGRect) {//이것이 parent것이므로.
//        <#code#>
//    }
    init(image:UIImage?, textField: UITextField) {
        super.init(frame: .zero)//우리만의 initializer만드므로 parent것 init필요. 그리고 우리가 나중에 프레임만들것이므로 frame = zero 설정.
        setHeight(height: 50)
        
        let iv = UIImageView()
        iv.image = image
        iv.tintColor = .white
        iv.alpha = 0.87
        
        addSubview(iv)//UIView Class므로 이렇게 선언해도된다.view.addSubview 이런식으로 안해도된다.
        iv.centerY(inView: self)
        iv.anchor(left: leftAnchor,paddingLeft: 8)
        iv.setDimensions(height: 24, width: 24)
        
        addSubview(textField)
        textField.centerY(inView: self)
        textField.anchor(left: iv.rightAnchor, bottom: bottomAnchor,right: rightAnchor,paddingLeft: 8, paddingBottom:  -4)
        
        let dividerView = UIView()
        dividerView.backgroundColor = .white
        addSubview(dividerView)
        dividerView.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingLeft: 8, height: 0.75)//디바이더 굵기.
        //left를 주면 right 도 줘야한다.
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
