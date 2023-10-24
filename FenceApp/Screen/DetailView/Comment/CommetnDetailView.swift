//
//  CommetnDetailView.swift
//  FenceApp
//
//  Created by JeonSangHyeok on 10/19/23.
//

import UIKit

class CommentDetailView: UIView {
    
    // MARK: - UI Properties
    private let navigationBar: UINavigationBar = {
        let navigationBar = UINavigationBar()
        return navigationBar
    }()
    
    private let leftLabelItem: UILabel = {
        let label = UILabel()
        label.text = "댓글"
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    let rightButtonItem: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    lazy var commentTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemPink
        tableView.register(CommentDetailTableViewCell.self, forCellReuseIdentifier: CommentDetailTableViewCell.identifier)
        return tableView
    }()
    
    let myCommentTextView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        return view
    }()
    
    let myProfileImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "코주부 원숭이"))
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleToFill
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.clear.cgColor
        return imageView
    }()
    
    let writeCommentTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.layer.cornerRadius = 5
        textView.backgroundColor = .yellow
        return textView
    }()
    
    // MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
        configureNavigationItems()
    }
    
    override func layoutSubviews() {
        myProfileImageView.layer.cornerRadius = 17.5
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Method
    private func configureNavigationItems() {
        navigationBar.items = [UINavigationItem()]
        navigationBar.items?[0].setLeftBarButton(UIBarButtonItem(customView: leftLabelItem), animated: false)
        navigationBar.items?[0].setRightBarButton(UIBarButtonItem(customView: rightButtonItem), animated: false)
    }
}

// MARK: - AutoLayout
private extension CommentDetailView {
    func configureUI() {
        configureNavigationBar()
        configureTableView()
        configureMyCommentTextFieldView()
    }
    
    func configureNavigationBar() {
        self.addSubview(navigationBar)
        
        navigationBar.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
    }
    
    func configureTableView() {
        self.addSubview(commentTableView)
        
        commentTableView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(112)
        }
    }
    
    func configureMyCommentTextFieldView() {
        self.addSubview(myCommentTextView)
        
        myCommentTextView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(100)
        }
        
        configureMyProfileImageView()
        configureMyCommentTextField()
    }
    
    func configureMyProfileImageView() {
        myCommentTextView.addSubview(myProfileImageView)
        
        myProfileImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(30)
            $0.leading.equalToSuperview().offset(10)
            $0.width.height.equalTo(35)
        }
    }
    
    func configureMyCommentTextField() {
        myCommentTextView.addSubview(writeCommentTextView)
        
        writeCommentTextView.snp.makeConstraints {
            $0.centerY.equalTo(myProfileImageView.snp.centerY)
            $0.leading.equalTo(myProfileImageView.snp.trailing).offset(10)
            $0.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(60)
        }
    }
}
