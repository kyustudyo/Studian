//
//  UIAnimatable.swift
//  stockApp
//
//  Created by 이한규 on 2021/10/17.
//

import Foundation
import MBProgressHUD

protocol UIAnimatable where Self:UIViewController {//uiviewcontroller에서만 사용가능하도록 정함. 이게 있어야 self.view가능.
    func showLoadingAnimation()
    func hideLoadingAnimation()
}

extension UIAnimatable { //protocol을 여기서 선언해서 사용도하네.
    func showLoadingAnimation(){
        DispatchQueue.main.async {
            MBProgressHUD.showAdded(to: self.view, animated: true)
        }
        
    }
    
    func hideLoadingAnimation(){
        DispatchQueue.main.async {//main에서만 작동하도록.
            MBProgressHUD.hide(for: self.view, animated: true)
        }
        
    }
    
//    func showLoadingAnimation2(){
//        DispatchQueue.global().async {
//            MBProgressHUD.showAdded(to: self.view, animated: true)
//        }
//    }
//    func hideLoadingAnimation2(){
//        DispatchQueue.global().async {//main에서만 작동하도록.
//            MBProgressHUD.hide(for: self.view, animated: true)
//        }
//    }
}
