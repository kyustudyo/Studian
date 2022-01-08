//
//  LoadingViewController.swift
//  fashion_app
//
//  Created by 이한규 on 2021/12/06.
//

import Foundation

//
//  LoadingViewController.swift
//  onboarding-fashion-app
//
//  Created by Kelvin Fok on 5/7/20.
//  Copyright © 2020 Kelvin Fok. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {
    
    private var inOnboardingSeen: Bool!
  
//
    private let navigationManager = NavigationManager()
    private let storageManager = StorageManager()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        //storageManager.resetOnboardingSeen()
        inOnboardingSeen = storageManager.isOnboardingSeen()
        
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showInitialScreen()//뷰디드로드에다 안하는이유는 스토리보드를 아직 안만든상태이기때문.
    }
//
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        showInitialScreen()
//    }
//
    private func showInitialScreen() {
        if inOnboardingSeen {
//            showMainApp()
            navigationManager.show(screen: .mainApp, inController: self)
        } else {
//            showOnboardingScreen()
            navigationManager.show(screen: .onboarding, inController: self)
        }
    }
//    private func showOnboardingScreen(){
//        let onboardingViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OnboardingViewController")
//
//        if let sceneDelegate = view.window?.windowScene?.delegate as? SceneDelegate, let window = sceneDelegate.window {
//            //scenedelegate에 있는 window
//            window.rootViewController = onboardingViewController
//            //ani
//            UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: nil, completion: nil)
//        }
//        //다시온보딩 으로 가고싶으면 스토리보드에서 아이디 주고 동일방법사용.
//    }
//    private func showMainApp(){
//        let mainAppViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainAppViewController")
//        if let sceneDelegate = view.window?.windowScene?.delegate as? SceneDelegate, let window = sceneDelegate.window {
//            //scenedelegate에 있는 window
//            window.rootViewController = mainAppViewController
//            //ani
//            UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: nil, completion: nil)
//        }
//        //다시온보딩 으로 가고싶으면 스토리보드에서 아이디 주고 동일방법사용.
//    }
    
}

