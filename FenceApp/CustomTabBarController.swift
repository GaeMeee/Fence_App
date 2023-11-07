//
//  CustomTabBarController.swift
//  FenceApp
//
//  Created by JeonSangHyeok on 10/16/23.
//

import UIKit

class CustomTabBarController: UITabBarController{

    let controllers: [UIViewController]
    let locationManager: LocationManager
    let firebaseFoundSerivce: FirebaseFoundService
    
    var finishUploadingFound: ((MissingType) -> Void)?
    
    lazy var cameraButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        button.setImage(UIImage(systemName: "camera"), for: .normal)
        button.tintColor = .white
//        button.backgroundColor = UIColor(hexCode: "5DDFDE")
        button.backgroundColor = UIColor(hexCode: "55BCEF")
        button.clipsToBounds = true
        button.layer.cornerRadius = 20
        button.isUserInteractionEnabled = true
        button.addTarget(self, action: #selector(cameraButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    init(controllers: [UIViewController], locationManager: LocationManager, firebaseFoundSerivce: FirebaseFoundService) {
        self.controllers = controllers
        self.locationManager = locationManager
        self.firebaseFoundSerivce = firebaseFoundSerivce
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        self.delegate = self
        
        configureTabBarControllers()
        setBackgroundColor()
        configureCameraButton()
    }
    
    // MARK: - Action
    @objc func cameraButtonTapped() {
        let camera = UIImagePickerController()
        
        camera.sourceType = .camera
        camera.allowsEditing = true
        camera.cameraDevice = .rear
        camera.cameraCaptureMode = .photo
        camera.delegate = self
        
        present(camera, animated: true)
    }
    
    
}

// MARK: - Private Method
extension CustomTabBarController {
    private func configureTabBarControllers() {
        let mapTabBarItem = UITabBarItem(title: "Map", image: UIImage(systemName: "map"), tag: 0)
//        mapTabBarItem.selectedImage = UIImage(systemName: "map.fill")
        mapTabBarItem.selectedImage = UIImage(systemName: "map")
        controllers[0].tabBarItem = mapTabBarItem
        
        let lostListTabBarItem = UITabBarItem(title: "Lost", image: UIImage(systemName: "menucard"), tag: 1)
        lostListTabBarItem.selectedImage = UIImage(systemName: "menucard")
        controllers[1].tabBarItem = lostListTabBarItem
        
        let dummyTabBarItem = UITabBarItem(title: nil, image: nil, tag: 2)
        controllers[2].tabBarItem = dummyTabBarItem
        
        let chatTabBarItem = UITabBarItem(title: "Found", image: UIImage(systemName: "message"), tag: 3)
        chatTabBarItem.selectedImage = UIImage(systemName: "message")
        controllers[3].tabBarItem = chatTabBarItem
        
        let myInfoTabBarItem = UITabBarItem(title: "My", image: UIImage(systemName: "person"), tag: 4)
        myInfoTabBarItem.selectedImage = UIImage(systemName: "person")
        controllers[4].tabBarItem = myInfoTabBarItem
    
        self.viewControllers = controllers
        
    }
    
    private func setBackgroundColor() {
        self.tabBar.barTintColor = .black
        
        self.tabBar.isTranslucent = false
//        self.tabBar.barTintColor = UIColor(hexCode: "5DDFDE")
        self.tabBar.tintColor = UIColor(hexCode: "55BCEF")
//        self.tabBar.tintColor = .black
        self.tabBar.unselectedItemTintColor = .black
        
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
//        appearance.configureWithTransparentBackground()
        self.tabBar.standardAppearance = appearance
        self.tabBar.scrollEdgeAppearance = appearance
        
    }
    
    private func configureCameraButton() {
        self.tabBar.addSubview(cameraButton)
        cameraButton.frame = CGRect(x: Int(self.tabBar.bounds.width / 2) - 25, y: -10, width: 50, height: 50)
    }
}

// MARK: - UITabBarControllerDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate
extension CustomTabBarController: UITabBarControllerDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate  {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController == controllers[2] {
            return false
        }
        return true
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage else { return }
        
        let currentLocation = locationManager.fetchLocation()
        
        guard let latitude = currentLocation?.latitude, let longitude = currentLocation?.longitude else { return }
        
        Task {
            do {
                let url = try await FirebaseImageUploadService.uploadeFoundImage(image: image)
                let foundDTD = FoundResponseDTO(latitude: latitude, longitude: longitude, imageURL: url, date: Date(), userIdentifier: "045RhOisSFgjp0AjR2DusTpDsyb2")
                try await firebaseFoundSerivce.createFound(foundResponseDTO: foundDTD)
                finishUploadingFound?(.found)
            } catch {
                print(error)
            }
        }
        
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
