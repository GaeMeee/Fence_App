//
//  PostInfoTableViewCell.swift
//  FenceApp
//
//  Created by JeonSangHyeok on 10/17/23.
//

import UIKit
import SnapKit
import MapKit

class PostInfoCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    static let identifier: String = "PostInfoCell"
    
    // MARK: - UI Properties
    let postTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "강아지 찾아주세요"
        label.font = UIFont.systemFont(ofSize: 24)
        label.textAlignment = .left
        label.backgroundColor = .red
        return label
    }()
    
    let lostTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "잃어버린 시간: \(Date())"
        label.font = UIFont.systemFont(ofSize: 20)
        label.textAlignment = .center
        label.backgroundColor = .yellow
        return label
    }()
    
    let postDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "강아지 잃어버렸어용ㅠㅠ강아지 잃어버렸어용ㅠㅠ강아지 잃어버렸어용ㅠㅠ강아지 잃어버렸어용ㅠㅠ강아지 잃어버렸어용ㅠㅠ강아지 잃어버렸어용ㅠㅠ강아지 잃어버렸어용ㅠㅠ강아지 잃어버렸어용ㅠㅠ강아지 잃어버렸어용ㅠㅠ강아지 잃어버렸어용ㅠㅠ강아지 잃어버렸어용ㅠㅠ강아지 잃어버렸어용ㅠㅠ강아지 잃어버렸어용ㅠㅠ강아지 잃어버렸어용ㅠㅠ강아지 잃어버렸어용ㅠㅠ강아지 잃어버렸어용ㅠㅠ"
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 18)
        label.backgroundColor = .red
        return label
    }()
    
    let mapView: MKMapView = {
        let mapView = MKMapView()
        return mapView
    }()
    
    // MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - AutoLayout
private extension PostInfoCollectionViewCell {
    func configureUI() {
        configurePostTitleLabel()
        configureLostTimeLabel()
        configureMapView()
        configurePostDescriptionLabel()
    }
    
    func configurePostTitleLabel() {
        contentView.addSubview(postTitleLabel)
        
        postTitleLabel.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.top).offset(5)
            $0.leading.equalTo(contentView.snp.leading).offset(10)
            $0.trailing.equalTo(contentView.snp.trailing).offset(-10)
            $0.height.equalTo(30)
        }
    }
    
    func configureLostTimeLabel() {
        contentView.addSubview(lostTimeLabel)
        
        lostTimeLabel.snp.makeConstraints {
            $0.top.equalTo(postTitleLabel.snp.bottom).offset(5)
            $0.leading.equalTo(contentView.snp.leading).offset(10)
            $0.trailing.equalTo(contentView.snp.trailing).offset(-10)
            $0.height.equalTo(30)
        }
    }
    
    func configurePostDescriptionLabel() {
        contentView.addSubview(postDescriptionLabel)
        
        postDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(lostTimeLabel.snp.bottom).offset(5)
            $0.leading.equalTo(contentView.snp.leading).offset(10)
            $0.trailing.equalTo(contentView.snp.trailing).offset(-10)
            $0.bottom.equalTo(mapView.snp.top).offset(-5)
        }
    }
    
    func configureMapView() {
        contentView.addSubview(mapView)
        
        mapView.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.leading.equalTo(contentView.snp.leading).offset(10)
            $0.trailing.equalTo(contentView.snp.trailing).offset(-10)
            $0.height.equalTo(250)
        }
    }
}
