//
//  SceneDelegate.swift
//  FenceApp
//
//  Created by JeonSangHyeok on 10/16/23.
//

import UIKit
import FirebaseFirestore

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    let firstTabNavigationController = UINavigationController()
    let secondTabNavigationController = UINavigationController()
    let thirdTabNavigationController = UINavigationController()
    let fourthTabNavigationController = UINavigationController()
    
    let locationManager = LocationManager()
    let firebaseFoundService = FirebaseFoundService()
    let firebaseLostCommentService = FirebaseLostCommentService()
    
    lazy var firebaseAuthService = FirebaseAuthService(firebaseUserService: firebaseUserService, firebaseLostService: firebaseLostService, firebaseLostCommentService: firebaseLostCommentService, firebaseFoundService: firebaseFoundService)
    
    lazy var firebaseUserService = FirebaseUserService(firebaseLostService: firebaseLostService, firebaseLostCommentService: firebaseLostCommentService)
    lazy var firebaseLostService = FirebaseLostService(firebaseLostCommentService: firebaseLostCommentService)
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        
        let launchScreenVC = LaunchScreenViewController()
        window?.rootViewController = launchScreenVC
        window?.makeKeyAndVisible()
        
        DispatchQueue.main.asyncAfter(deadline: .now()+2) { [weak self] in
            Task {
                do {
                    try await self?.checkUserLoggedIn()
                } catch {
                    try self?.firebaseAuthService.signOutUser()
                    print(error)
                    self?.window?.rootViewController = self?.makeLoginVC()
                }
            }
        }
    }
                                      

    
    private func checkUserLoggedIn() async throws {
        
        let isUserLoggedIn = firebaseAuthService.checkIfUserLoggedIn()
        
        if isUserLoggedIn && locationManager.fetchStatus() == true {
            
            let userIdentifier = try firebaseAuthService.getCurrentUser().uid
            
            let userResponseDTO = try await firebaseUserService.fetchUser(userIdentifier: userIdentifier)
            
            let user = UserResponseDTOMapper.makeFBUser(from: userResponseDTO)
            
            CurrentUserInfo.shared.currentUser = user
            
            window?.rootViewController = makeTabbarController()
            
            
        } else {
            try firebaseAuthService.signOutUser()
            window?.rootViewController = makeLoginVC()
        }
    }
    
    private func setNavigationControllers() {
        firstTabNavigationController.viewControllers = [makeMapViewVC()]
        secondTabNavigationController.viewControllers = [makeLostViewVC()]
        thirdTabNavigationController.viewControllers = [makeChatViewController()]
        fourthTabNavigationController.viewControllers = [makeMyInfoViewController()]
    }
    
    private func makeTabbarController() -> CustomTabBarController {
        
        setNavigationControllers()
        
        let TabbarController = CustomTabBarController(controllers: [firstTabNavigationController, secondTabNavigationController, makeDummyViewController(), thirdTabNavigationController, fourthTabNavigationController], locationManager: locationManager, firebaseFoundSerivce: firebaseFoundService)
        
        return TabbarController
    }
    
    private func makeMapViewVC() -> MapViewController {
        
        let mapViewController = MapViewController(firebaseLostService: firebaseLostService, firebaseFoundService: firebaseFoundService, locationManager: locationManager)
        
        mapViewController.filterTapped = { filterModel in
            
            let filterViewController = CustomFilterModalViewController(filterModel: filterModel)
            
            filterViewController.delegate = mapViewController
            
            mapViewController.present(filterViewController, animated: true)
            
        }
        
        mapViewController.annotationViewTapped = { [weak self] pinable in
            
            guard let self else { return }
            
            let modalViewController = pinable is Lost ? self.makeLostModalVC(lost: pinable as! Lost) : self.makeFoundModalVC(found: pinable as! Found)

            mapViewController.present(modalViewController, animated: true)
        }
        
        return mapViewController
    }
    
    private func makeLostModalVC(lost: Lost) -> LostModalViewController {
        
        let lostModalViewController = LostModalViewController(lost: lost)
        
        lostModalViewController.transitToDetailVC = { [weak self] lost in
            
            guard let self else { return }
            
            let detailViewController = DetailViewController(lost: lost,
                                                            firebaseCommentService: self.firebaseLostCommentService,
                                                            firebaseUserService: self.firebaseUserService,
                                                            firebaseAuthService: self.firebaseAuthService)
            lostModalViewController.dismiss(animated: true)
            
            self.firstTabNavigationController.pushViewController(detailViewController, animated: true)
            
        }
        
        return lostModalViewController
    }
    
    private func makeFoundModalVC(found: Found) -> FoundModalViewController {
        
        let foundModalViewController = FoundModalViewController(found: found)
        return foundModalViewController
    }
    
    
    private func makeLoginVC() -> LoginViewController {
        
        let vc = LoginViewController(firebaseAuthService: firebaseAuthService, firebaseUserService: firebaseUserService, locationManager: locationManager) { [weak self] in
            
            guard let self else { return }
            
            self.setNavigationControllers()
            
            self.window?.rootViewController = self.makeTabbarController()
        }
        
        return vc
    }
    
    
    private func makeDetailVC(lost: Lost) -> DetailViewController {
        let detailViewController = DetailViewController(lost: lost,
                                                        firebaseCommentService: firebaseLostCommentService,
                                                        firebaseUserService: firebaseUserService,
                                                        firebaseAuthService: firebaseAuthService)
        return detailViewController
    }
    
    
    private func makeLostViewVC() -> LostListViewController {
        let lostCellTapped = { [weak self] lost in
            
            guard let self else { return }
            
            let detailViewController = self.makeDetailVC(lost: lost)
            
            self.secondTabNavigationController.pushViewController(detailViewController, animated: true)
        }
        
        let vc = LostListViewController(fireBaseLostService: firebaseLostService, firebaseLostCommentService: firebaseLostCommentService, firebaseAuthService: firebaseAuthService, firebaseUserService: firebaseUserService, lostCellTapped: lostCellTapped)
        
        vc.filterTapped = { filterModel in
            
            let filterViewController = CustomFilterModalViewController(filterModel: filterModel)
            
            filterViewController.delegate = vc
            
            vc.present(filterViewController, animated: true)
            
        }
        
        return vc
    }
    
    
    private func makeDummyViewController() -> UIViewController {
        let vc = UIViewController()
        return vc
    }
    
    
    private func makeChatViewController() -> ChatViewController {
        let vc = ChatViewController(firebaseFoundService: firebaseFoundService)
        vc.filterTapped = { filterModel in
            let filterViewController = CustomFilterModalViewController(filterModel: filterModel)
            filterViewController.delegate = vc
            vc.present(filterViewController, animated: true)
        }
        return vc
    }
    
   
    
    
    private func makeMyInfoViewController() -> MyInfoViewController {
        let vc = MyInfoViewController(firebaseLostService: firebaseLostService, firebaseFoundService: firebaseFoundService, firebaseAuthService: firebaseAuthService)
        
        vc.logOut = { [weak self] in
            self?.window?.rootViewController = self?.makeLoginVC()
        }
        return vc
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
}


