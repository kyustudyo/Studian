//
//  ViewController.swift
//  Studian
//
//  Created by 이한규 on 2021/10/22.
//

import UIKit

class TestViewController: UIViewController {
//    @IBOutlet weak var txt1 : UILabel!
    var purposeViewModel = PurposesViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let label = UILabel(frame: CGRect.zero)
        label.text = "Home View Controller"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.clipsToBounds = true
        label.sizeToFit()
        
        self.view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("home")
    }
}






