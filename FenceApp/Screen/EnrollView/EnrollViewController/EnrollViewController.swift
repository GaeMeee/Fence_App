//
//  EnrollViewController.swift
//  FenceApp
//
//  Created by t2023-m0067 on 10/18/23.
//

import UIKit
import SnapKit

class EnrollViewController: UIViewController {

    private let enrollView = EnrollView()
    
    override func loadView() {
        view = enrollView
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavBar()
        
    }
    
    
    @objc func tapRightBarBtn(){
        print("clickRight")
    }
    
    @objc func tapLeftBarBtn(){
        self.navigationController?.popViewController(animated: true)
    }
}

extension EnrollViewController {
    func configureNavBar(){
        self.title = "게시글 등록"
        let appearance = UINavigationBarAppearance()
        // 불투명한 색상의 백그라운드 생성 (불투명한 그림자를 한겹을 쌓는다)
        appearance.configureWithOpaqueBackground()
        // 우측 버튼
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(tapRightBarBtn))
        // NavigationItem back 버튼 숨기기
        navigationItem.hidesBackButton = true
        // 좌측 버튼
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "multiply"), style: .plain, target: self, action: #selector(tapLeftBarBtn))
    }
}
