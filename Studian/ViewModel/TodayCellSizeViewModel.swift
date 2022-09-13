//
//  TodayCellSizeViewModel2.swift
//  Studian
//
//  Created by 이한규 on 2022/02/01.
//

import Foundation
import UIKit
struct TodayCellSizeViewModel {
    
    
    var width :CGFloat
    var indexPathRow: Int = Int.min
    var countOfToday : Int = 0
    var selectedInt : Set<Int> = []
    
    var isItLastMember : Bool {
        countOfToday - 1 == indexPathRow ? true : false
    }
    
    var height : CGFloat {
        if indexPathRow % 2 == 0 {
            if selectedInt.contains(indexPathRow){
                return width / 2.5 + 100
            }
            else { return width / 2.5 }
        }
        else {
            if selectedInt.map({$0+1}).contains(indexPathRow){
                return 30
            }
            else {
                return 0
            }
            
        }
        
    }
    var cellSize : CGSize {
        return .init(width: width, height: height)
    }

}
