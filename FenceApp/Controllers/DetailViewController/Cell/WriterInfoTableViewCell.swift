//
//  WriterInfoTableViewCell.swift
//  FenceApp
//
//  Created by JeonSangHyeok on 10/17/23.
//

import UIKit

class WriterInfoCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    static let identifier: String = "WriterInfoCell"

    // MARK: - UI Properties
    let writerProfileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "코주부 원숭이")
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.clear.cgColor
        
        return imageView
    }()
    
    let writerNickNameLabel: UILabel = {
        let label = UILabel()
        label.text = "코주부 원숭이"
        label.font = UIFont.systemFont(ofSize: 20)
        label.textAlignment = .left
        label.backgroundColor = .red
        return label
    }()
    
    let postWriteTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "\(Calendar.current.dateComponents([.minute], from: Date()))"
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .systemGray
        label.textAlignment = .center
        label.backgroundColor = .yellow
        return label
    }()
    
    // MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    override func layoutSubviews() {
        writerProfileImageView.layer.cornerRadius = 25
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - AutoLayout
private extension WriterInfoCollectionViewCell {
    func configureUI() {
        configureWriterProfileImageView()
        configureWriterNickNameLabel()
        configurePostWriteTimeLabel()
    }
    
    func configureWriterProfileImageView() {
        contentView.addSubview(writerProfileImageView)
        
        writerProfileImageView.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.top).offset(10)
            $0.leading.equalTo(contentView.snp.leading).offset(10)
            $0.width.height.equalTo(50)
        }
    }
    
    func configureWriterNickNameLabel() {
        contentView.addSubview(writerNickNameLabel)
        
        writerNickNameLabel.snp.makeConstraints {
            $0.centerY.equalTo(writerProfileImageView.snp.centerY)
            $0.leading.equalTo(writerProfileImageView.snp.trailing).offset(10)
            $0.width.equalTo(200)
            $0.height.equalTo(50)
        }
    }
    
    func configurePostWriteTimeLabel() {
        contentView.addSubview(postWriteTimeLabel)
        
        postWriteTimeLabel.snp.makeConstraints {
            $0.centerY.equalTo(writerProfileImageView.snp.centerY)
            $0.leading.equalTo(writerNickNameLabel.snp.trailing)
            $0.trailing.equalTo(contentView.snp.trailing).offset(-10)
            $0.height.equalTo(50)
        }
    }
}
