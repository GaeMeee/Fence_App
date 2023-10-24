//
//  TestCollectionViewCell.swift
//  FenceApp
//
//  Created by JeonSangHyeok on 10/18/23.
//

import UIKit
import SnapKit

class ImageViewCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    static let identifier: String = "ImageViewCell"
    
    // MARK: - UI Properties
    let imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "코주부 원숭이"))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    // MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - AutoLayout
    private func configure() {
        contentView.addSubview(imageView)
        
        imageView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
    }
}
