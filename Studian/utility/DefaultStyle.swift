//
//  DefaultStyle.swift
//  Studian
//
//  Created by 이한규 on 2021/11/11.
//

import UIKit
public enum DefaultStyle {
    public enum Colors {
        public static let tint: UIColor = {
            if #available(iOS 13.0, *) {
                return UIColor { traitCollction in//유아이컬러를 리턴하는데, 반환할때 트레잇컬렉션이 다크모드인지 아닌지나온다. 플레이어들어갔을때 슬라이더와 버튼이 무슨색나올지 대응한것.
                    if traitCollction.userInterfaceStyle == .dark {
                        return .white
                    } else {
                        return .black
                    }
                }
            } else {
                return .black
            }
        }()
        
//        public static let notTint: UIColor = {
//            if #available(iOS 13.0, *) {
//                return UIColor { traitCollction in//유아이컬러를 리턴하는데, 반환할때 트레잇컬렉션이 다크모드인지 아닌지나온다. 플레이어들어갔을때 슬라이더와 버튼이 무슨색나올지 대응한것.
//                    if traitCollction.userInterfaceStyle == .dark {
//                        return .black
//                    } else {
//                        return .white
//                    }
//                }
//            } else {
//                return .black
//            }
//        }()
        
        
    }
}
