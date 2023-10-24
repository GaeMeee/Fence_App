//
//  ImageSlideTableViewCell.swift
//  FenceApp
//
//  Created by JeonSangHyeok on 10/17/23.
//

import UIKit

class ImageSlideTableViewCell: UITableViewCell {
    
    static let identifier: String = "ImageSlideCell"
    
    var nowPage: Int = 0

    var imageCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.identifier)
        collectionView.decelerationRate = .fast
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = 3
        pageControl.currentPage = 0
        return pageControl
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        configureUI()
        
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
    }
}

private extension ImageSlideTableViewCell {
    func configureUI() {
        configureImageCollectionView()
        configurePageControl()
    }
    
    func configureImageCollectionView() {
        self.addSubview(imageCollectionView)
        
        imageCollectionView.snp.makeConstraints {
            $0.top.equalTo(self.snp.top)
            $0.leading.equalTo(self.snp.leading)
            $0.trailing.equalTo(self.snp.trailing)
            $0.height.equalTo(300)
        }
    }
    
    func configurePageControl() {
        self.addSubview(pageControl)
        
        pageControl.snp.makeConstraints {
            $0.centerY.equalTo(self.snp.top).offset(285)
            $0.centerX.equalToSuperview()
        }
    }
}

extension ImageSlideTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = imageCollectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifier, for: indexPath) as! ImageCollectionViewCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: imageCollectionView.frame.width, height: imageCollectionView.frame.height)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if velocity.x > 0 {
            self.nowPage += 1
        } else if velocity.x < 0 {
            self.nowPage -= 1
            
            if self.nowPage < 0 {
                self.nowPage = 0
            }
        }
        pageControl.currentPage = nowPage
    }
}
