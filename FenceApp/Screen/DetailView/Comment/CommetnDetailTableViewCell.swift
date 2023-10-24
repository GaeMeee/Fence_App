//
//  CommetnDetailTableViewCell.swift
//  FenceApp
//
//  Created by JeonSangHyeok on 10/19/23.
//

import UIKit

class CommentDetailTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    static let identifier: String = "CommentDetailCell"
    
    // MARK: - UI Properties
    let commentUserProfileImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "코주부 원숭이"))
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleToFill
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.clear.cgColor
        return imageView
    }()
    
    let commentTextLabel: UILabel = {
        let label = UILabel()
        label.text = "발견했어요~~발견했어요~~발견했어요~~"
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private var commentTextLabelBottomConstraint: NSLayoutConstraint!

    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        configureUI()
    }
    
    override func layoutSubviews() {
        commentUserProfileImageView.layer.cornerRadius = 12.5
    }
}

// MARK: - AutoLayout
private extension CommentDetailTableViewCell {
    func configureUI() {
        configureCommentUserProfileImageView()
    }
    
    func configureCommentUserProfileImageView() {
        contentView.addSubview(commentUserProfileImageView)
        
        commentUserProfileImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.leading.equalToSuperview().offset(10)
            $0.width.height.equalTo(25)
        }
    }
}
