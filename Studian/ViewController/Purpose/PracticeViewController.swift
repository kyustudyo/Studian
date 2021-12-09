


import UIKit
import Combine

class PractiveViewController : UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    private let containerView : UIView = {
        let uiView = UIView()
        uiView.backgroundColor = .groupTableViewBackground
        return uiView
    }()
    
 
    private let plusPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "2")
        button.imageView?.contentMode = .scaleAspectFill//이거 안하면 좀 이상하게 나온다.
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleSelectPhoto), for: .touchUpInside)
        button.layer.cornerRadius = 15
        button.clipsToBounds = true//이걸해야 동그라게 나온다. 안에들어갈 사진들이.
        return button
    }()
    
    @Published private var bigTextView = CustomTextView()
    
    @Published private var smallTextView = CustomTextView()
    
    @objc func handleSelectPhoto() {//처음 누를때
        print("select")
//        showLoadingAnimation()
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion:  nil
        )
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.view.addSubview(containerView)
        containerView.centerX(inView: view)
        containerView.centerY(inView: view)
        containerView.setWidth(width: UIScreen.main.bounds.width - 50)
        //containerView.setHeight(height: 200)
        //containerView.backgroundColor = .red
        
        
        var stackView = UIStackView(arrangedSubviews: [
            plusPhotoButton,
            bigTextView,
            smallTextView
        ])
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.alignment = .center
        stackView.distribution = .fill
        plusPhotoButton.setHeight(height: UIScreen.main.bounds.height/4)
        plusPhotoButton.setWidth(width: UIScreen.main.bounds.height/4)
        
        plusPhotoButton.backgroundColor = .blue
        bigTextView.setHeight(height: 80)
        smallTextView.setHeight(height: 80)
        bigTextView.anchor( left: stackView.leftAnchor, right: stackView.rightAnchor, paddingLeft:0 , paddingRight:0 )
        smallTextView.anchor( left: stackView.leftAnchor, right: stackView.rightAnchor, paddingLeft:0 , paddingRight:0 )
        
        containerView.addSubview(stackView)
        stackView.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, paddingTop: 24, paddingLeft: 24, paddingBottom: 24, paddingRight: 24)
    }
}




