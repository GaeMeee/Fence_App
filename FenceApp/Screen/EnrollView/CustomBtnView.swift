//
//  CustomBtnView.swift
//  FenceApp
//
//  Created by t2023-m0067 on 10/19/23.
//

import UIKit
import SnapKit

class CustomBtnView: UIView {

    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .cyan
        
        return view
    }()

    private let cameraImgView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "camera.fill")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let label: UILabel = {
        let label = UILabel()
        label.text = "0/5"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension CustomBtnView {
    
    private func configureUI(){
        addSubview(containerView)
        containerView.addSubview(cameraImgView)
        containerView.addSubview(label)
        
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        cameraImgView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.leading.trailing.equalToSuperview()
            $0.width.equalTo(25) // 원하는 이미지 너비로 설정
            $0.height.equalTo(25) // 원하는 이미지 높이로 설정
        }

        label.snp.makeConstraints {
            $0.top.equalTo(cameraImgView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
   
}
