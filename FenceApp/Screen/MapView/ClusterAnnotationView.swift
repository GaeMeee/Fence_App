//
//  ClusterAnnotationView.swift
//  FenceApp
//
//  Created by Woojun Lee on 10/20/23.
//

import MapKit

class ClusterAnnotationView: MKAnnotationView {
    
    static let identifier = "ClusterAnnotationView1"
    
    let label: UILabel = {
       let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
        override var annotation: MKAnnotation? {
            didSet {
                displayPriority = .defaultHigh

                
                collisionMode = .circle
                
                frame = CGRect(x: 0, y: 0, width: 40, height: 40)
                centerOffset = CGPoint(x: 0, y: -frame.size.height / 2)
                
            }
        }
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.annotation = annotation
        configureUI()
    }
    
   
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        self.layer.cornerRadius = 20
        self.backgroundColor = .systemBlue
        addSubview(label)
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setTitle(count: Int) {
        label.text = String(count)
    }
}
