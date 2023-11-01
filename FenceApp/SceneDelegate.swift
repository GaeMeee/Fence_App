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
//        try! firebaseAuthService.signOutUser()
       
        Task {
//
            do {
//                try firebaseAuthService.signOutUser()
//                let userUID = try firebaseAuthService.getCurrentUser().uid
//                let user = try await firebaseUserService.fetchUser(userIdentifier: userUID)
//                print(user, "!!!@@@")
//                try await firebaseAuthService.signInUser(email: "aaa@gmail.com", password: "123456")
//                try firebaseAuthService.signOutUser()
                checkUserLoggedIn()
                window?.makeKeyAndVisible()
            } catch {
                print(error)
            }
        }
    }
    
    private func checkUserLoggedIn() {
        if firebaseAuthService.checkIfUserLoggedIn() == false {
            window?.rootViewController = makeLoginVC()
            
        } else {
            setNavigationControllers()
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
        let TabbarController = CustomTabBarController(controllers: [firstTabNavigationController, secondTabNavigationController, makeDummyViewController(), thirdTabNavigationController, fourthTabNavigationController], locationManager: locationManager, firebaseFoundSerivce: firebaseFoundService)
        
        return TabbarController
    }
    
    private func makeMapViewVC() -> MapViewController {
        
        let vc = MapViewController(firebaseLostService: firebaseLostService, firebaseFoundService: firebaseFoundService, locationManager: locationManager)
        
        vc.filterTapped = {
            let filterViewController = CustomFilterModalViewController()
            filterViewController.delegate = vc
            vc.present(filterViewController, animated: true)
        }
        return vc
    }
    
    private func makeLoginVC() -> LoginViewController {
        let vc = LoginViewController(firebaseAuthService: firebaseAuthService, firebaseUserService: firebaseUserService) {
            self.setNavigationControllers()
            self.window?.rootViewController = self.makeTabbarController()
        }
        
        return vc
    }
    
    
    private func makeLostViewVC() -> LostListViewController {
        let vc = LostListViewController(fireBaseLostService: firebaseLostService, firebaseLostCommentService: firebaseLostCommentService, firebaseAuthService: firebaseAuthService, firebaseUserService: firebaseUserService)
        
        vc.filterTapped = {
            let filterModalViewController = CustomFilterModalViewController()
            filterModalViewController.delegate = vc
            vc.present(filterModalViewController, animated: true)
        }
        
        return vc
    }
    
    
    private func makeDummyViewController() -> UIViewController {
        let vc = UIViewController()
        return vc
    }
    
    
    private func makeChatViewController() -> ChatViewController {
        let vc = ChatViewController(firebaseFoundService: firebaseFoundService)
        return vc
    }
    
    
    private func makeMyInfoViewController() -> MyInfoViewController {
        let vc = MyInfoViewController(firebaseLostService: firebaseLostService, firebaseFoundService: firebaseFoundService)
        return vc
    }
}



//Task {
//    do {
//                        var lostWithDocument: LostWithDocument?
//                        var lostResponseArray: [LostResponseDTO] = []
//        
//                        lostWithDocument = try await firebaseLostService.fetchLostsWithPagination(int: 3)
//        
//                        lostResponseArray.append(contentsOf: lostWithDocument!.lostResponseDTOs)
//        
//        
//        
//                        lostResponseArray.forEach { lostResponseDTO in
//                            print(lostResponseDTO.lostIdentifier, "(((((")
//                        }
//                        lostWithDocument = try await firebaseLostService.fetchLostsWithPagination(int: 3, lastDocument: lostWithDocument!.lastDocument)
//        
//                        lostResponseArray.append(contentsOf: lostWithDocument!.lostResponseDTOs)
//        
//                        lostResponseArray.forEach { lostResponseDTO in
//                            print(lostResponseDTO.lostIdentifier, "(((((")
//                        }
//                        firebaseUserService.listenToUpdateOn(userIdentifier: "045RhOisSFgjp0AjR2DusTpDsyb2") { result in
//                            switch result {
//                            case .failure(let error):
//                                print(error)
//                            case .success(let userResponseDTO):
//                                print(userResponseDTO.email, "!!!!!!!")
//        
//        
//                            }
//                        }
//                        try await firebaseAuthService.signInUser(email: "aaa@gmail.com", password: "123456")
//                        let a = firebaseAuthService.checkIfUserLoggedIn()
//                        print(a)
//        
//                var foundWithDocument: FoundWithDocument?
//                var foundResponseArray: [FoundResponseDTO] = []
//
//                foundWithDocument = try await firebaseFoundService.fetchFoundsWithPagination(int: 3)
//
//                foundResponseArray.append(contentsOf: foundWithDocument!.foundResponseDTOs)
//
//                foundResponseArray.forEach { foundResponseDTO in
//                    print(foundResponseDTO.foundIdentifier, "((((((")
//                }
//
//                foundWithDocument = try await firebaseFoundService.fetchFoundsWithPagination(int: 3, lastDocument: foundWithDocument!.lastDocument)
//
//                foundResponseArray.append(contentsOf: foundWithDocument!.foundResponseDTOs)
//
//                foundResponseArray.forEach { foundResponseDTO in
//                    print(foundResponseDTO.foundIdentifier, "(((((")
//                }
//        
//        
//        
//    } catch {
//        print(error, "@@@@@@@@")
//    }
//}
