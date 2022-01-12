//
//  LoadingViewController.swift
//  fashion_app
//
//  Created by 이한규 on 2021/12/06.
//

import Foundation

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
    private func showInitialScreen() {
        if inOnboardingSeen {
            navigationManager.show(screen: .mainApp, inController: self)
        } else {
            navigationManager.show(screen: .onboarding, inController: self)
        }
    }
}

