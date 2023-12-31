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
    
    let commentTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CommentDetailTableViewCell.self, forCellReuseIdentifier: CommentDetailTableViewCell.identifier)
        tableView.separatorStyle = .none
        return tableView
    }()
    
    let myCommentTextView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let myProfileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.clear.cgColor
        return imageView
    }()
    
    
    let writeCommentTextView: UITextView = {
        let textView = UITextView()
        textView.text = "댓글을 입력해주세요."
        textView.textColor = .lightGray
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.layer.cornerRadius = 20
        textView.textContainerInset.left = 5
        textView.textContainerInset.right = 45
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.black.cgColor
        textView.isScrollEnabled = false
        return textView
    }()
    
    let commentSendButton: UIButton = {
        let button = UIButton()
        button.setTitle("작성", for: .normal)
        button.setTitleColor(UIColor(hexCode: "5DDFDE"), for: .normal)
        return button
    }()
    
    // MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
        configureNavigationItems()
    }
    
    override func layoutSubviews() {
        myProfileImageView.layer.cornerRadius = 17.5
        myCommentTextView.layer.addBorder(edge: .top, color: .black, thickness: 1)
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
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(100)
        }
    }
    
    func configureMyCommentTextFieldView() {
        self.addSubview(myCommentTextView)
        
        myCommentTextView.snp.makeConstraints {
            $0.height.greaterThanOrEqualTo(50)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.lessThanOrEqualToSuperview()
        }
        
        configureMyCommentTextField()
        configureCommentSendButton()
    }
    
    func configureMyCommentTextField() {
        myCommentTextView.addSubview(writeCommentTextView)
        
        writeCommentTextView.snp.makeConstraints {
            $0.top.greaterThanOrEqualToSuperview().inset(10)
            $0.leading.trailing.equalToSuperview().inset(15)
            $0.bottom.equalToSuperview().inset(30)
        }
    }
    
    func configureCommentSendButton() {
        myCommentTextView.addSubview(commentSendButton)
        
        commentSendButton.snp.makeConstraints {
            $0.trailing.equalTo(writeCommentTextView.snp.trailing).inset(10)
            $0.bottom.equalTo(writeCommentTextView.snp.bottom).inset(3)
        }
    }
}

extension CALayer {

  func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat) {

    let border = CALayer()

    switch edge {
    case UIRectEdge.top:
        border.frame = CGRect(x: 0, y: 0, width: frame.width, height: thickness)

    case UIRectEdge.bottom:
        border.frame = CGRect(x:0, y: frame.height - thickness, width: frame.width, height:thickness)

    case UIRectEdge.left:
        border.frame = CGRect(x:0, y:0, width: thickness, height: frame.height)

    case UIRectEdge.right:
        border.frame = CGRect(x: frame.width - thickness, y: 0, width: thickness, height: frame.height)

    default: do {}
    }

    border.backgroundColor = color.cgColor

    addSublayer(border)
 }
}
