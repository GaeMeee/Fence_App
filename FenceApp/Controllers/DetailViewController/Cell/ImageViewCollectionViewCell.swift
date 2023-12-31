//
//  TestCollectionViewCell.swift
//  FenceApp
//
//  Created by JeonSangHyeok on 10/18/23.
//

import UIKit
import SnapKit
import Kingfisher

class ImageViewCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    static let identifier: String = "ImageViewCell"
    
    // MARK: - UI Properties
    let imageView: UIImageView = {
        let imageView = UIImageView()
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
    
    func setImage(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        imageView.kf.setImage(with: url)
    }
    
    func clearImage() {
        imageView.image = nil
    }
    
    // MARK: - AutoLayout
    private func configure() {
        contentView.addSubview(imageView)
        
        imageView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
    }
}
