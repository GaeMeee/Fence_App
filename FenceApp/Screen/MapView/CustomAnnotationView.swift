//
//  CustomAnnotationView.swift
//  FenceApp
//
//  Created by Woojun Lee on 10/20/23.
//

import MapKit

class CustomAnnotationView: MKAnnotationView {
    
    static let identifier = "CustomAnnotationView"
    
    override var annotation: MKAnnotation? {
        didSet {
            
            clusteringIdentifier = "shop"
            //            image = UIImage(systemName: "house")
        }
    }
    
    lazy var customImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleToFill
        view.backgroundColor = .lightGray
        view.clipsToBounds = true
        return view
    }()
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        self.layer.cornerRadius = 40 / 2
        configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configUI() {
        self.clipsToBounds = true
        configureCustomImageView()
    }
    
    private func configureCustomImageView() {
        self.addSubview(customImageView)
        
        customImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setImage(image: UIImage) {
        customImageView.image = image
    }
    
    // Annotation도 재사용을 하므로 재사용 전 값을 초기화 시켜서 다른 값이 들어가는 것을 방지
    override func prepareForReuse() {
        super.prepareForReuse()
        customImageView.image = nil
        
    }
    
    
    
    // 이 메서드는 annotation이 뷰에서 표시되기 전에 호출됩니다.
    // 즉, 뷰에 들어갈 값을 미리 설정할 수 있습니다
    //    override func prepareForDisplay() {
    //        super.prepareForDisplay()
    //
    //        guard let annotation = annotation as? CustomAnnotation else { return }
    //
    //        titleLabel.text = annotation.title
    //
    //        guard let imageName = annotation.imageName,
    //              let image = UIImage(named: imageName) else { return }
    //
    //        customImageView.image = image
    //
    //        // 이미지의 크기 및 레이블의 사이즈가 변경될 수도 있으므로 레이아웃을 업데이트 한다.
    //        setNeedsLayout()
    //
    //        // 참고. drawing life cycle :
    //        // setNeedsLayout를 통해 다음 런루프에서 레이아웃을 업데이트하도록 예약
    //        // -> layoutSubviews을 통해 레이아웃 업데이트
    //
    //        // layoutSubviews를 쓰려면 setNeedsLayout도 항상 같이 사용해야 한다고 하네요.
    //    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
}
