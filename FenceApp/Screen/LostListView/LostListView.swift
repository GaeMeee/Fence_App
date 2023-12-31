//
//  LostListView.swift
//  FenceApp
//
//  Created by t2023-m0067 on 10/16/23.
//

import UIKit
import SnapKit

protocol lostListViewDelegate: AnyObject {
    func tapFilterButton()
}

class LostListView: UIView {
    
    weak var delegate: lostListViewDelegate?
    
    let filterLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .darkGray
        lb.font = UIFont.systemFont(ofSize: 13)
        lb.text = "전체 리스트"
        return lb
    }()
    
    lazy var lostTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.backgroundColor = .white
        tableView.directionalLayoutMargins = .init(top: 0, leading: 18, bottom: 0, trailing: 18)
        tableView.register(LostListViewCell.self, forCellReuseIdentifier: "LostListViewCell")
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 3, bottom: 0, right: 3)
        tableView.separatorColor = .gray
        return tableView
    }()
    
    lazy var filterBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "line.3.horizontal.decrease.circle.fill", withConfiguration:UIImage.SymbolConfiguration(weight: .medium))?
            .applyingSymbolConfiguration(UIImage.SymbolConfiguration(paletteColors:[.white, .systemGray2])), for: .normal)
        btn.contentVerticalAlignment = .fill
        btn.contentHorizontalAlignment = .fill
//        btn.withShadow(color: .accent, opacity: 1, offset: CGSize(width: 0, height: 2), radius: 4)
        btn.addTarget(self, action: #selector(tapFilterBtutton), for: .touchUpInside)
        return btn
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func tapFilterBtutton(){
        delegate?.tapFilterButton()
    }

}

extension LostListView {
    
    func configureUI(){
        self.addSubview(filterLabel)
        self.addSubview(lostTableView)
        self.addSubview(filterBtn)

        filterLabel.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).offset(5)
            $0.leading.equalToSuperview().offset(23)
            $0.trailing.equalToSuperview().offset(-23)
        }
        
        lostTableView.snp.makeConstraints {
            $0.top.equalTo(filterLabel.snp.bottom).offset(7)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
            
        }
        
        filterBtn.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(10)
            $0.width.equalTo(60)
            $0.height.equalTo(59)
            $0.bottom.equalToSuperview().inset(30)
        }
    }
}


