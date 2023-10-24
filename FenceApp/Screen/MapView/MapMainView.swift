//
//  MapMainView.swift
//  FenceApp
//
//  Created by Woojun Lee on 10/17/23.
//

import UIKit
import SnapKit
import MapKit

class MapMainView: UIView {
    
    
    //MARK: - Properties
    
    private lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        
        mapView.delegate = self
        mapView.register(CustomAnnotationView.self, forAnnotationViewWithReuseIdentifier: CustomAnnotationView.identifier)
        
        
        mapView.register(ClusterAnnotationView.self, forAnnotationViewWithReuseIdentifier: ClusterAnnotationView.identifier)
        return mapView
    }()
    
    private let segmentedControl: UISegmentedControl = {
        let view = UISegmentedControl()
        view.isUserInteractionEnabled = true
        view.backgroundColor = .white
        view.insertSegment(withTitle: "lost", at: 0, animated: true)
        view.insertSegment(withTitle: "found", at: 1, animated: true)
        view.selectedSegmentIndex = 0
        return view
    }()
    
    private let optionImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "house")
        return iv
    }()
    
    private let locationImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "person")
        return iv
    }()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Actions
    
    //MARK: - Helpers
    
    //MARK: - UI
    
    private func configureUI() {
        configureMapView()
        configureSegmentedControl()
        configureLocationImageView()
        configureOptionImageView()
    }
    
    private func configureMapView() {
        addSubview(mapView)
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func configureSegmentedControl() {
        addSubview(segmentedControl)
        segmentedControl.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(50)
            make.centerX.equalToSuperview()
            make.width.equalTo(150)
            make.height.equalTo(40)
        }
    }
    
    private func configureLocationImageView() {
        addSubview(locationImageView)
        locationImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().inset(100)
            make.width.height.equalTo(45)
        }
    }
    
    private func configureOptionImageView() {
        addSubview(optionImageView)
        optionImageView.snp.makeConstraints { make in
            make.bottom.equalTo(locationImageView.snp.top)
            make.trailing.equalToSuperview().inset(10)
            make.width.height.equalTo(45)
        }
    }
    
}

extension MapMainView: MKMapViewDelegate {
    
}
