//
//  StorageManager.swift
//  fashion_app
//
//  Created by 이한규 on 2021/12/06.
//

import Foundation

//user default 는 한 가지 데이터만을 가져오고 싶어도 모든 plist를 로드하기 때문에 많이 저장하지 말자.
class StorageManager {
    enum Key: String{
        case onboardingSeen
        case lastOpenDate
    }
    let defaults = UserDefaults.standard
    func isOnboardingSeen()->Bool {
        defaults.bool(forKey: Key.onboardingSeen.rawValue)//"onboardingSeen"이런식으로 하면 잘못쳐서 실수 할 수 도 있으므로.
    }
    
    func SetlastOpenDate() {
        defaults.set(Date(), forKey: Key.lastOpenDate.rawValue)
    }
    
    func getLastOpenDate() -> Date? {
        guard let date = defaults.object(forKey: Key.lastOpenDate.rawValue) as? Date else{
            return nil
        }
        return date
    }
    
    func SetOnboardingSeen(){
        defaults.set(true, forKey: Key.onboardingSeen.rawValue)
    }
    
    func resetOnboardingSeen(){//test 를 위해
        defaults.set(false, forKey: Key.onboardingSeen.rawValue)
    }
    
    
}
