//
//  TabItem.swift
//  CustomTabNavigation
//
//  Created by Sprinthub on 09/10/2019.
//  Copyright © 2019 Sprinthub Mobile. All rights reserved.
//

// Changed by Agha Saad Rehman

import UIKit

enum TabItem: String, CaseIterable {
    case home = "home"
    case calender = "calender"
    case friends = "friends"
    case profile = "profile"
    
    
    var viewController: UIViewController {
        switch self {
        case .home:
            print("home")
            return TestViewController()
        case .calender:
            return StudianMainPageViewController()
        case .friends:
            return TestViewController()
        case .profile:
            return TestViewController()
        //default : return StudianMainPageViewController()
        }
    }
    
    var icon: UIImage? {
        switch self {
        case .home:
            return UIImage(named: "1")!
        case .calender:
            return UIImage(named: "1")!
        case .friends:
            return UIImage(named: "1")!
        case .profile:
            return UIImage(named: "1")!
        }
    }
    
    var displayTitle: String {
        return self.rawValue.capitalized(with: nil)
    }
}
