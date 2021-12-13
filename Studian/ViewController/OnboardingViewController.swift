//
//  OnboardingViewController.swift
//  Studian
//
//  Created by 이한규 on 2021/12/02.
//

import UIKit

class OnboardingViewController: UIViewController,UIAnimatable {
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var darkView: UIView!
    
    
    private let storageManager = StorageManager()
    private let navigationManager = NavigationManager()
    
    private var items: [OnboardingItem] = []
    
    private var currentPage: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateFunc()
        setSwipeGestures()
        setupPlaceholderItems()
        setupPageControl()
        setupScreen(index: currentPage)
        //setupGestures()
        setupViews()
        updateBackgroundImage(index: currentPage)
        // Do any additional setup after loading the view.
    }
    
    private func updateFunc(){
        storageManager.SetOnboardingSeen()
    }
    private func setupPlaceholderItems() {
        items = OnboardingItem.placeholderItems
    }
    
    private func setupPageControl() {
        pageControl.numberOfPages = items.count + 1 // 마지막 하나 더 있도록
    }
    private func setupViews() {//너무 밝아서.
        darkView.backgroundColor = UIColor.init(white: 0.1, alpha: 0.5)
    }
    private func setupScreen(index: Int) {
        var index = index
        if index >= 2 { index = 1}//광클 하면 올라가므로 방지.
        titleLabel.text = items[index].title
        detailLabel.text = items[index].detail
        pageControl.currentPage = index
        titleLabel.alpha = 1.0
        detailLabel.alpha = 1.0
        titleLabel.transform = .identity//제자리
        detailLabel.transform = .identity
    }
    
    
    private func setSwipeGestures(){//사용안함.
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture(_ : )))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swipeRight)
    }
    @objc func respondToSwipeGesture(_ gesture: UIGestureRecognizer){
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            print("!!")
            switch swipeGesture.direction {
            case .left :
                handleTapAnimation()
                print("right!")
            default: break
            }
        }
    }
    private func setupGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapAnimation))
        view.addGestureRecognizer(tapGesture)
    }
    private func updateBackgroundImage(index: Int) {
        let image = items[index].bgImage
        UIView.transition(with: bgImageView,
                          duration: 0.5,
                          options: .transitionCrossDissolve,
                          animations: { self.bgImageView.image = image },
                          completion: nil)
        
    }
    
    @objc private func handleTapAnimation() {
        print("tap")
        // first animation - title label
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {

            self.titleLabel.alpha = 0.8
            self.titleLabel.transform = CGAffineTransform(translationX: -30, y: 0)

        }) { _ in//completion

            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                self.titleLabel.alpha = 0
                self.titleLabel.transform = CGAffineTransform(translationX: 0, y: -550)
            }, completion: nil)
        }
//
//        // second animation - detail label
//          //0.5초 딜레이는 앞에것 해야하므로 쉬는것.
        UIView.animate(withDuration: 0.5, delay: 0.5, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            self.detailLabel.alpha = 0.8
            self.detailLabel.transform = CGAffineTransform(translationX: -30, y: 0)
        }) { _ in

            if self.currentPage < self.items.count - 1 {
                self.updateBackgroundImage(index: self.currentPage + 1)//index초과하면 크래쉬남.
            }
            
//            if self.currentPage < self.items.count - 1 {
//                self.updateBackgroundImage(index: self.currentPage + 1)
//            }

            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                self.detailLabel.alpha = 0
                self.detailLabel.transform = CGAffineTransform(translationX: 0, y: -550)
            }) { _ in
                print("the end")
                self.currentPage += 1
               
                //self.setupScreen(index: self.currentPage)
                if self.isOverLastItem() {
                    self.showLoadingAnimation()
                    
                    self.navigationManager.show(screen: .mainApp, inController: self)
                    
                    
                    //self.showMainApp()
                } else {
                    //self.showLoadingAnimation()
                    
                    self.setupScreen(index: self.currentPage)
                   // self.hideLoadingAnimation()
                }
            }
        }
    }
    private func isOverLastItem() -> Bool {
        return currentPage == self.items.count
    }
    private func showMainApp() {
        
        let mainAppViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainAppViewController")
        //to do the transition i have to change the root controller from the window itself.
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let sceneDelegate = windowScene.delegate as? SceneDelegate,
            let window = sceneDelegate.window {//this is what you need to do to have to get access to this window right here.
            window.rootViewController = mainAppViewController
            //rootview바꿔버리기
            UIView.transition(with: window,
                              duration: 0.25,
                              options: .transitionCrossDissolve,
                              animations: nil,
                              completion: nil)//부드럽게 넘어가기위해서
        }
        
    }

    

}

struct OnboardingItem {
    
    let title: String
    let detail: String
    let bgImage: UIImage?
    
    static let placeholderItems: [OnboardingItem] = [
        .init(title: "Memo your dream\nWith images",
              detail: "Make important things stand out.\n\n-Mary Kay Ash-",
              bgImage: UIImage(named: "img")),
        
        .init(title: "Schedule your day",
              detail: "A goal without a plan is just a dream.\n\n-Antoine de Saint-Exupéry-",
              bgImage: UIImage(named: "img1")),
        
    ]
}
