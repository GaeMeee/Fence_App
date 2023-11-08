//
//  SettingModalViewController.swift
//  FenceApp
//
//  Created by JeonSangHyeok on 11/8/23.
//

import UIKit

class SettingModalViewController: UIViewController {
    
    
    let firebaseAuthService: FirebaseAuthService
    var logOut: ( () -> Void )?
    
    lazy var settingListTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        return tableView
    }()
    
    init(firebaseAuthService: FirebaseAuthService) {
        self.firebaseAuthService = firebaseAuthService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        setSelf()
    }
    
    func setSelf() {
        view.backgroundColor = .white
        self.modalTransitionStyle = .coverVertical
        self.modalPresentationStyle = .pageSheet
        
        if let sheet = self.sheetPresentationController {
            let smllId = UISheetPresentationController.Detent.Identifier("settingSmall")
            let smallDetent = UISheetPresentationController.Detent.custom(identifier: smllId) { context in
                return 120
            }
            sheet.detents = [smallDetent]
        }
    }
    
    func configureUI() {
        view.addSubview(settingListTableView)
        
        settingListTableView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(90)
        }
    }
}

extension SettingModalViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if indexPath.row == 0 {
            cell.textLabel?.text = "로그아웃"
            return cell
        } else {
            cell.textLabel?.text = "회원탈퇴"
            cell.textLabel?.textColor = .red
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let alertController = UIAlertController(title: "로그아웃", message: "로그아웃 하시겠습니까?", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            let confirmAction = UIAlertAction(title: "확인", style: .default) { [weak self] action in
                
                do {
                    try self?.firebaseAuthService.signOutUser()
                    self?.logOut?()
                    
                } catch {
                    self?.logOut?()
                }
            }
            
            alertController.addAction(confirmAction)
            alertController.addAction(cancelAction)
            present(alertController, animated: true, completion: nil)
        } else {
            let alertController = UIAlertController(title: "회원탈퇴", message: "회원탈퇴 하시겠습니까?", preferredStyle: .alert)
            alertController.addTextField { emailTextField in
                emailTextField.placeholder = "이메일을 입력해주세요"
            }
            alertController.addTextField { passwordTextField in
                passwordTextField.placeholder = "비밀번호를 입력해주세요"
                passwordTextField.isSecureTextEntry = true
            }
            let cancelAction = UIAlertAction(title: "취소", style: .cancel)
            let confirmAction = UIAlertAction(title: "확인", style: .default) { [weak self] action in
                guard let email = alertController.textFields?[0].text else { return }
                guard let password = alertController.textFields?[1].text else { return }
                Task {
                    do {
                        try await self?.firebaseAuthService.deleteUser(email: email, password: password)
                        self?.logOut?()
                    } catch {
                        self?.logOut?()
                    }
                }
            }
            alertController.addAction(cancelAction)
            alertController.addAction(confirmAction)
            present(alertController, animated: true)
        }
    }
}