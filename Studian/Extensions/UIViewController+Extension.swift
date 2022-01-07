//
//  UIViewController+Extension.swift
//  Studian
//
//  Created by 이한규 on 2021/12/04.
//

import Foundation
import UIKit

extension UIViewController {
    static let customIndicator :UIActivityIndicatorView = UIActivityIndicatorView()
    func startIndicator()
    {
        let bc = UIView()
        bc.backgroundColor = DefaultStyle.Colors.notTint
        let uiimageview = UIImageView()
        uiimageview.contentMode = .scaleAspectFill//없으면 찌그러져 보인다.
        uiimageview.image = UIImage(named: "1024")
        
        bc.addSubview(uiimageview)
        uiimageview.centerX(inView: bc)
        uiimageview.centerY(inView: bc)
        uiimageview.setWidth(width: 200)
        uiimageview.setHeight(height: 50)
        
        let loadingView: UIView = UIView()
        bc.addSubview(loadingView)
        loadingView.setWidth(width: 118)
        loadingView.setHeight(height: 80)
        loadingView.anchor(top: uiimageview.bottomAnchor,
                           paddingTop: 0)
        loadingView.centerX(inView: bc)
        loadingView.backgroundColor = DefaultStyle.Colors.notTint
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        
        let label = UILabel()
        label.text = "Loading..."
        label.textColor = DefaultStyle.Colors.notTint
        label.font = .init(name: "Jua-Regular", size: 15)
        loadingView.addSubview(label)
        label.anchor(top: loadingView.topAnchor, paddingTop: 5)
        label.centerX(inView: loadingView)
        label.setDimensions(height: 20,width: 59)
        
        loadingView.addSubview(UIViewController.customIndicator)
        UIViewController.customIndicator.style = UIActivityIndicatorView.Style.large
        UIViewController.customIndicator.centerX(inView: loadingView)
        UIViewController.customIndicator.anchor(top: label.bottomAnchor, paddingTop: 0)
        UIViewController.customIndicator.setDimensions(height: 40, width: 40)
        
        view.addSubview(bc)
        bc.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                  left: view.safeAreaLayoutGuide.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor,
                  right: view.safeAreaLayoutGuide.rightAnchor, paddingTop: 0,
                  paddingLeft: 0,
                  paddingBottom: 0,
                  paddingRight: 0)
        UIViewController.customIndicator.startAnimating()
    }
    
    func stopIndicator()
    {
//        UIApplication.shared.endIgnoringInteractionEvents()
        UIViewController.customIndicator.stopAnimating()
        ((UIViewController.customIndicator.superview as UIView?)?.superview as UIView?)!.removeFromSuperview()
    }
}
