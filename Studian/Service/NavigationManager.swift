//
//  NavigationManager.swift
//  fashion_app
//
//  Created by 이한규 on 2021/12/06.
//

import UIKit // storyboard

class NavigationManager {
    
    enum Screen {
        case onboarding
        case mainApp
    }
    func show(screen: Screen, inController : UIViewController){
        var viewController : UIViewController!
        
        switch screen {
        case .onboarding:
            viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OnboardingViewController")
        case .mainApp:
            viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainAppViewController")
        }
        
        
        
        
        if let sceneDelegate = inController.view.window?.windowScene?.delegate as? SceneDelegate, let window = sceneDelegate.window {
            //scenedelegate에 있는 window
            window.rootViewController = viewController
            //ani
            UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: nil, completion: nil)
        }
        //다시온보딩 으로 가고싶으면 스토리보드에서 아이디 주고 동일방법사용.
        
        
        
        
        
        
        
        
    }
}
