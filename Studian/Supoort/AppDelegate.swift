//
//  AppDelegate.swift
//  Studian
//
//  Created by 이한규 on 2021/10/22.
//

import UIKit
import CoreData
@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        print("앱의 첫 뷰컨트롤러보다 먼저나오는 메소드.시작하자마자.")
        print("file이 저장되는곳:\(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last ?? "" as String)")
        // Override point for customization after application launch.
//        let window = UIWindow(frame: UIScreen.main.bounds)
//        
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let testimageCardView = storyboard.instantiateViewController(withIdentifier: "TestimageCardView")
//        let tabBarController = UITabBarController()
//        tabBarController.viewControllers = [testimageCardView]
//        window.rootViewController = tabBarController
//        window.makeKeyAndVisible()
        
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        print("갑자기 전화오면 저장해놔야지.")
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        print("앱이 화면에서 사라질때")
        print("home button같은.")
        print("다른앱을 켤때")
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        
        saveContext()//coredata
        
        
        print("it is caused by user or system")
        print("내 앱을 쓰다가 홈버튼 가서 다른 앱들어갔는데, 그 다른앱이 리소스 너무 많이 사용하는 애면 백그라운드에 있는 내 앱을 terminate할 수 있다.")
        print("스와이프 해서 위로 올리는것도 terminate.")
        print("또한 업데이트 할때도.앱이나, os.")
        
        print("위의 applicationDidEnterBackground 보다 여기에 저장 하는것을 넣는게 낫다.")
        
    }
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    //sql lite database 라 생각.
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    

    // MARK: - Core Data Saving support
    //앱꺼질때.
    //git의 staging area라 생각.
    //커밋전에 이것저것 수정하는.
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }



}

