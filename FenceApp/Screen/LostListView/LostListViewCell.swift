//
//  LostListViewCell.swift
//  FenceApp
//
//  Created by t2023-m0067 on 10/17/23.
//

import UIKit
import SnapKit

class LostListViewCell: UITableViewCell {
    
    let lostimgView: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(systemName: "person")
//        img.clipsToBounds = true
        img.layer.cornerRadius = img.frame.size.width / 2
//        img.layer.cornerRadius = img.frame.height / 2
        img.layer.masksToBounds = true
        img.backgroundColor = .cyan
        return img
    }()
    
    let titleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "test"
        lb.font = UIFont.systemFont(ofSize: 18)
        lb.textColor = .black
        lb.backgroundColor = .systemPink
        return lb
    }()
    
    let dateLabel: UILabel = {
        let lb = UILabel()
        lb.text = "test"
        lb.font = UIFont.systemFont(ofSize: 14)
        lb.textColor = .black
        lb.backgroundColor = .green
        return lb
    }()
    
    let nickNameLabel: UILabel = {
        let lb = UILabel()
        lb.text = "test"
        lb.font = UIFont.systemFont(ofSize: 14)
        lb.textColor = .black
        lb.backgroundColor = .yellow
        return lb
    }()

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        configureUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
    
}

extension LostListViewCell {
    
    func configureUI(){
        self.addSubviews(lostimgView, titleLabel, dateLabel, nickNameLabel)
        
        lostimgView.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
            $0.width.equalTo(110)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(5)
            $0.leading.equalTo(lostimgView.snp.trailing).offset(10)
            $0.trailing.equalToSuperview()

        }
        
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(5)
            $0.leading.equalTo(lostimgView.snp.trailing).offset(10)
            $0.trailing.equalToSuperview()
        }
        
        nickNameLabel.snp.makeConstraints {
            $0.leading.equalTo(lostimgView.snp.trailing).offset(10)
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-5)
        }

    }
}
