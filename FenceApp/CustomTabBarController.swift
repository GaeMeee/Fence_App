//
//  CustomTabBarController.swift
//  FenceApp
//
//  Created by JeonSangHyeok on 10/16/23.
//

import UIKit

class CustomTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTabBarControllers()
    }
    
    private func configureTabBarControllers() {
        let mapViewController = MapViewController()
        let mapTabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "map"), tag: 0)
        mapViewController.tabBarItem = mapTabBarItem
        
        let lostListViewController = LostListViewController()
        let lostListTabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "menucard"), tag: 1)
        let lostListNavigationController = UINavigationController(rootViewController: lostListViewController)
        lostListNavigationController.tabBarItem = lostListTabBarItem
        
        let cameraViewController = CameraViewController()
        let cameraTabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "camera"), tag: 2)
        cameraViewController.tabBarItem = cameraTabBarItem
        
        let chatViewController = ChatViewController()
        let chatTabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "message"), tag: 3)
        chatViewController.tabBarItem = chatTabBarItem
        
        let myInfoViewController = MyInfoViewController()
        let myInfoTabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "person"), tag: 4)
        myInfoViewController.tabBarItem = myInfoTabBarItem
        
        self.viewControllers = [mapViewController, lostListNavigationController, cameraViewController, chatViewController, myInfoViewController]
          
        self.tabBar.barTintColor = UIColor(red: 93, green: 223, blue: 222, alpha: 1)
        self.tabBar.unselectedItemTintColor = .gray
    }
}
