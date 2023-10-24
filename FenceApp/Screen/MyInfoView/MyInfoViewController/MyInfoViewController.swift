//
//  MyInfoViewController.swift
//  FenceApp
//
//  Created by JeonSangHyeok on 10/16/23.
//

//import UIKit
//
//class MyInfoViewController: UIViewController {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Do any additional setup after loading the view.
//    }
//    
//
//
//
//}
import UIKit


class MyInfoViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextFieldDelegate {
    let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 60
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(named: "profile_image")
        iv.backgroundColor = .color1
        return iv
    }()
    
    let nicknameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "닉네임"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    let memoTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "간단한 메모"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        return textField
    }()

    let editProfileButton: UIButton = {
        let button = UIButton()
        button.setTitle("프로필 편집", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.layer.borderWidth = 1.0
        button.layer.cornerRadius = 10.0
        button.layer.borderColor = UIColor.blue.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(editProfile), for: .touchUpInside)
        return button
    }()
    
    let lostCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical // 세로 방향으로 설정합니다.
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .lightGray
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.isScrollEnabled = true // 스크롤 활성화
        return collectionView
    }()

    let lostLabel: UILabel = {
        let label = UILabel()
        label.text = "Lost"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addProfileImage()
        addTextFields()
        addEditProfileButton()
        addLostCollectionView()
        
        nicknameTextField.delegate = self
        memoTextField.delegate = self

        lostCollectionView.delegate = self
        lostCollectionView.dataSource = self
    }

    func addProfileImage() {
        view.addSubview(profileImageView)
        
        profileImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 120).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 120).isActive = true
    }
    
    func addTextFields() {
        view.addSubview(nicknameTextField)
        view.addSubview(memoTextField)
        
        nicknameTextField.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 16).isActive = true
        nicknameTextField.topAnchor.constraint(equalTo: profileImageView.topAnchor, constant: 10).isActive = true
        nicknameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true

        memoTextField.leadingAnchor.constraint(equalTo: nicknameTextField.leadingAnchor).isActive = true
        memoTextField.topAnchor.constraint(equalTo: nicknameTextField.bottomAnchor, constant: 16).isActive = true
        memoTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
    }
    
    func addEditProfileButton() {
        view.addSubview(editProfileButton)

        editProfileButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        editProfileButton.topAnchor.constraint(equalTo: memoTextField.bottomAnchor, constant: 30).isActive = true
        editProfileButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        editProfileButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }

    @objc func editProfile() {
        nicknameTextField.becomeFirstResponder()
    }

    func addLostCollectionView() {
        view.addSubview(lostLabel)
        view.addSubview(lostCollectionView)
        
        lostLabel.topAnchor.constraint(equalTo: editProfileButton.bottomAnchor, constant: 20).isActive = true
        lostLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        lostCollectionView.topAnchor.constraint(equalTo: lostLabel.bottomAnchor, constant: 10).isActive = true
        lostCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        lostCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        lostCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true // 컬렉션 뷰가 화면 하단까지 닿도록 설정합니다.
    }

    // UICollectionViewDelegateFlowLayout 프로토콜을 구현하여 셀의 크기를 정의합니다.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (lostCollectionView.bounds.width - 40) / 2 // 컬렉션 뷰의 너비를 절반으로 나눈 값으로 설정합니다.
        return CGSize(width: width, height: width) // 너비와 높이를 같은 값으로 반환하여 정사각형 모양으로 만듭니다.
        
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2 // 컬렉션뷰의 섹션 개수를 2개로 설정합니다.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1 // 하나의 셀만 표시하도록 개수를 1로 설정합니다.
    }
    

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        
        if indexPath.section == 0 {
            cell.backgroundColor = .systemPink // 원하는 배경색으로 설정합니다.
        }
        if indexPath.section == 1 {
            cell.backgroundColor = .color1 // 원하는 배경색으로 설정합니다.
        }
        
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 {
            return UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        } else {
            return UIEdgeInsets(top: 40, left: 0, bottom: 20, right: 0)
        }
    }
}
