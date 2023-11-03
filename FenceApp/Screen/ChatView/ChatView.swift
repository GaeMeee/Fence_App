//
//  ChatView.swift
//  FenceApp
//
//  Created by JeonSangHyeok on 10/23/23.
//

import UIKit

protocol ChatViewDelegate: AnyObject {
    func filterButtonTapped()
}

class ChatView: UIView {
    
    // MARK: - Properties
    weak var delegate: ChatViewDelegate?
    
    // MARK: - UI Properties
    let foundCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = 2
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ChatCollectionViewCell.self, forCellWithReuseIdentifier: ChatCollectionViewCell.identifier)
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    lazy var filterButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "line.3.horizontal.decrease.circle.fill"), for: .normal)
        button.tintColor = UIColor(hexCode: "5DDFED")
        button.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let filterLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.text = "거리 - 반경 20km 내 / 시간 - 1일 이내 / 동물 - 전체"
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    // MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func filterButtonTapped() {
        delegate?.filterButtonTapped()
    }
}

// MARK: - AutoLayout
private extension ChatView {
    func configureUI() {
        configureFilterLabel()
        configureFoundCollectionView()
        configureFilterButton()
    }
    
    func configureFilterLabel() {
        self.addSubview(filterLabel)
        
        filterLabel.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).offset(5)
            $0.leading.trailing.equalToSuperview().inset(10)
        }
    }
    
    func configureFoundCollectionView() {
        self.addSubview(foundCollectionView)
        
        foundCollectionView.snp.makeConstraints {
            $0.top.equalTo(filterLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.bottom.equalTo(self.safeAreaLayoutGuide)
        }
    }
    
    func configureFilterButton() {
        self.addSubview(filterButton)
        
        filterButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(10)
            $0.width.equalTo(43)
            $0.height.equalTo(42)
            $0.bottom.equalToSuperview().inset(20)
        }
    }
}
