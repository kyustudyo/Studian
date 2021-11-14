//
//  MenuButton.swift
//  FloatingButtons
//
//  Created by 이한규 on 2021/10/14.
//

import UIKit

class MenuButton: UIView {

    private var menuButton : UIButton!
    private var menuStack : UIStackView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addMenuButton()//이렇게하네.
        addMenuStack()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
extension MenuButton {
    private func addMenuButton(){
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "tray", withConfiguration: UIImage.SymbolConfiguration(textStyle: .largeTitle))
        button.setImage(image, for: .normal)
        button.tintColor = .systemBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(button)
        
        let buttonTopConstraint = button.topAnchor.constraint(equalTo: topAnchor)
        //buttonTopConstraint.priority = .defaultHigh//낮춘거다.
        buttonTopConstraint.priority = .defaultLow
        buttonTopConstraint.isActive = true
        button.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        button.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        button.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        button.addTarget(self, action: #selector(tapMenuButton), for: .touchUpInside)//이렇게 안하고 바로 액션해도되지만.
        menuButton = button
        
    }
    @objc private func tapMenuButton(){
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: { [self] in
            // self.menuStack 으로 해도되지만 [self] in 으로 한번에 해도된다.
            menuStack.arrangedSubviews.forEach { button in
                button.isHidden = !button.isHidden
            }
            menuStack.layoutIfNeeded()
            
            
        } ,completion: nil)

        
    }
    private func addMenuStack(){
        let stack = UIStackView()
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        let buttonImageNames = ["pencil","person.fill","photo","bubble.left.and.bubble.right"]
        buttonImageNames.forEach { imageName in
            let button = UIButton(type: .system)
            let image = UIImage(systemName: imageName,withConfiguration: UIImage.SymbolConfiguration(textStyle: .largeTitle))
            button.setImage(image, for: .normal)
            stack.addArrangedSubview(button)
            button.isHidden = true
            button.tintColor = .brown
        
        }
        addSubview(stack)
        stack.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        stack.bottomAnchor.constraint(equalTo: menuButton.topAnchor, constant: -8).isActive = true
        let stackTopConstraint = stack.topAnchor.constraint(equalTo: topAnchor)
        //stackTopConstraint.priority = .defaultHigh//해도되고 안해도된다.
        stackTopConstraint.isActive = true
        menuStack = stack
    }
}
