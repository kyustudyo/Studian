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
//        bc.backgroundColor = .black
        
        let uiimageview = UIImageView()
        uiimageview.contentMode = .scaleAspectFill//없으면 찌그러져 보인다.
        
//        print("ss\(UIColor.black)")
//        print("ss\(UIColor.white)")
        
//        if DefaultStyle.Colors.tint == UIColor.black {
            uiimageview.image = UIImage(named: "1024")
//        }
//        if DefaultStyle.Colors.tint == UIColor.white {
//            uiimageview.image = UIImage(named: "1024_2")
//        }
        bc.addSubview(uiimageview)
        //uiimageview.setDimensions(height: 200, width: 100)
        uiimageview.centerX(inView: bc)
        uiimageview.centerY(inView: bc)
        uiimageview.setWidth(width: 200)
        uiimageview.setHeight(height: 50)
        
        
        //creating view to background while displaying indicator
//        let container: UIView = UIView()
//        container.frame = self.view.frame
//        container.center = self.view.center
//        container.center.y = self.view.center.y / 2
//        container.backgroundColor = container.backgroundColor

        
        
        //creating view to display lable and indicator
        let loadingView: UIView = UIView()
        bc.addSubview(loadingView)
        loadingView.setWidth(width: 118)
        loadingView.setHeight(height: 80)
        loadingView.anchor(top: uiimageview.bottomAnchor,paddingTop: 0)
        loadingView.centerX(inView: bc)
        loadingView.backgroundColor = DefaultStyle.Colors.notTint
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
////
//        loadingView.frame = CGRect(x: 0, y: 0, width: 118, height: 80)
////        bc.addSubview(loadingView)
//////        loadingView.center = self.view.center
////        loadingView.anchor(top: uiimageview.bottomAnchor,paddingTop: 10)
////        loadingView.centerY(inView: bc)
////        loadingView.centerX(inView: bc)
////        //loadingView.center.y = self.view.center.y / 2
//        loadingView.backgroundColor =  loadingView.backgroundColor
//        loadingView.clipsToBounds = true
//        loadingView.layer.cornerRadius = 10
////
////        //Preparing activity indicator to load
//        self.activityIndicator = UIActivityIndicatorView()
//        self.activityIndicator.frame = CGRect(x: 40, y: 12, width: 40, height: 40)
//        self.activityIndicator.style = UIActivityIndicatorView.Style.medium
//        loadingView.addSubview(activityIndicator)
////
////        //creating label to display message
//        let label = UILabel(frame: CGRect(x: 5, y: 55, width: 120, height: 20))
        let label = UILabel()
        label.text = "Loading..."
        label.textColor = DefaultStyle.Colors.notTint
//        label.font = UIFont.systemFont(ofSize: 25)
        label.font = .init(name: "Jua-Regular", size: 15)
//        label.bounds = CGRect(x: 0, y: 0, width: loadingView.frame.size.width/2, height: loadingView.frame.size.height/2)
        loadingView.addSubview(label)
        label.anchor(top: loadingView.topAnchor, paddingTop: 5)
        label.centerX(inView: loadingView)
//        print("k-1",loadingView.heightAnchor)
//        print("k0",loadingView.layer.bounds.width)
//        print("k1",loadingView.frame.height / 2,loadingView.frame.width / 2)
//        print("k2",loadingView.bounds.height / 2,loadingView.bounds.width / 2)
        label.setDimensions(height: 20,width: 59)
//        label.setDimensions(height: 50, width: 30)
//        label.setHeight(height: 30)
//        label.setWidth(width: 50)
        
//        self.activityIndicator = UIActivityIndicatorView()
//        self.activityIndicator.style = UIActivityIndicatorView.Style.large
        
        
//        UIViewController.customIndicator = UIActivityIndicatorView()
        UIViewController.customIndicator.style = UIActivityIndicatorView.Style.large
        //let activityIndicator = UILabel()
        //activityIndicator.text = "sdsd"
        //activityIndicator.textColor = UIColor.white
        loadingView.addSubview(UIViewController.customIndicator)
        UIViewController.customIndicator.centerX(inView: loadingView)
        UIViewController.customIndicator.anchor(top: label.bottomAnchor, paddingTop: 0)
        UIViewController.customIndicator.setDimensions(height: 40, width: 40)
        
//
////
//        label.bounds = CGRect(x: 0, y: 0, width: loadingView.frame.size.width/2, height: loadingView.frame.size.height/2)
//        label.font = UIFont.systemFont(ofSize: 12)
//        loadingView.addSubview(label)
////
//////        container.addSubview(loadingView)
////        bc.addSubview(loadingView)
//
//
//        bc.addSubview(loadingView)
//        loadingView.centerY(inView: uiimageview)
//        loadingView.centerX(inView: uiimageview)
        
//        self.view.addSubview(container)
        self.view.addSubview(bc)
        bc.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        
        UIViewController.customIndicator.startAnimating()
    }
    func stopIndicator()
    {
        UIApplication.shared.endIgnoringInteractionEvents()
        UIViewController.customIndicator.stopAnimating()
        ((UIViewController.customIndicator.superview as UIView?)?.superview as UIView?)!.removeFromSuperview()
    }
    
}
