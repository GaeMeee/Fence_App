//
//  CommentView.swift
//  FenceApp
//
//  Created by JeonSangHyeok on 10/18/23.
//

import UIKit

class CommentCollectionViewCell: UICollectionViewCell {
    
    static let identifier: String = "CommentCell"
    
    lazy var commentView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemGray.cgColor
        view.layer.cornerRadius = 15
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private let dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        return view
    }()
    
    private let commentLabel: UILabel = {
        let label = UILabel()
        label.text = "댓글"
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    private let commentTriangleImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "triangle.fill"))
        imageView.tintColor = .black
        return imageView
    }()
    
    let commentImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "코주부 원숭이"))
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.clear.cgColor
        return imageView
    }()
    
    let commentTextLabel: UILabel = {
        let label = UILabel()
        label.text = "암낭ㄴ망ㄴ망ㄴ망ㄴ마안ㅁ람날ㄴ말ㄴ말암낭ㄴ망ㄴ망ㄴ망ㄴ마안ㅁ람날ㄴ말ㄴ말암낭ㄴ망ㄴ망ㄴ망ㄴ마안ㅁ람날ㄴ말ㄴ말암낭ㄴ망ㄴ망ㄴ망ㄴ마안ㅁ람날ㄴ말ㄴ말"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .left
        label.numberOfLines = 2
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    override func layoutSubviews() {
        commentImageView.layer.cornerRadius = 15
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension CommentCollectionViewCell {
    func configureUI() {
        configureCommentView()
    }
    
    func configureCommentView() {
        contentView.addSubview(commentView)
        
        commentView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview().inset(5)
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().inset(10)
        }
        
        configureCommentLable()
        configureCommentTriangleImageView()
        configureDivierView()
        configureCommentImageView()
        configureCommentTextLabel()
    }
    
    func configureCommentLable() {
        commentView.addSubview(commentLabel)
        
        commentLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(10)
            $0.height.equalTo(22)
            $0.width.equalTo(40)
        }
    }
    
    func configureCommentTriangleImageView() {
        commentView.addSubview(commentTriangleImageView)
        
        commentTriangleImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().inset(15)
            $0.width.height.equalTo(15)
        }
    }
    
    func configureCommentImageView() {
        commentView.addSubview(commentImageView)
        
        commentImageView.snp.makeConstraints {
            $0.top.equalTo(commentLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(10)
            $0.width.height.equalTo(30)
        }
    }
    
    func configureDivierView() {
        commentView.addSubview(dividerView)
        
        dividerView.snp.makeConstraints {
            $0.top.equalTo(commentLabel.snp.bottom).offset(2)
            $0.leading.equalToSuperview().offset(5)
            $0.trailing.equalToSuperview().inset(5)
            $0.height.equalTo(0.5)
        }
    }
    
    func configureCommentTextLabel() {
        commentView.addSubview(commentTextLabel)
        
        commentTextLabel.snp.makeConstraints {
            $0.centerY.equalTo(commentImageView.snp.centerY)
            $0.leading.equalTo(commentImageView.snp.trailing).offset(10)
            $0.trailing.equalToSuperview().inset(5)
            $0.height.equalTo(40)
        }
    }
}
