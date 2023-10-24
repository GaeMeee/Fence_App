//
//  MapViewController.swift
//  FenceApp
//
//  Created by JeonSangHyeok on 10/16/23.
//

import UIKit
import MapKit
import SnapKit

class MapViewController: UIViewController {
    
    //MARK: - Properties
    
    var lostResponseDTOs: [LostResponseDTO] = []
    var foundResponseDTOs: [FoundResponseDTO] = []
    var pinTogether: [Pinable] = []
    let firebaseLostService: FirebaseLostService
    let firebaseFoundService: FirebaseFoundService
    
    let mapMainView = MapMainView()
    
    lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.showsUserLocation = true
        mapView.delegate = self
        
        mapView.register(CustomAnnotationView.self, forAnnotationViewWithReuseIdentifier: CustomAnnotationView.identifier)
        mapView.register(ClusterAnnotationView.self, forAnnotationViewWithReuseIdentifier: ClusterAnnotationView.identifier)
        mapView.register(MKUserLocationView.self, forAnnotationViewWithReuseIdentifier: "user")
        return mapView
    }()
    
    let locationManager: LocationManager
    
    //MARK: - Lifecycle
    
//    override func loadView() {
//        view = mapMainView
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "제목을 바꿔요 손모가지 검"
        
                
        configureUI()
       
        
        Task {
            do {
                lostResponseDTOs = try await firebaseLostService.fetchLosts()
                foundResponseDTOs = try await firebaseFoundService.fetchFounds()
                pinTogether = lostResponseDTOs + foundResponseDTOs
                setPinUsingMKAnnotation(pinables: pinTogether)
            } catch {
                print(error)
            }
        }
        
        centerViewOnUserLocation()
      
    }
    
    init(firebaseLostService: FirebaseLostService, firebaseFoundService: FirebaseFoundService, locationManager: LocationManager) {
        
        self.firebaseLostService = firebaseLostService
        self.firebaseFoundService = firebaseFoundService
        self.locationManager = locationManager
        print("I am inited")
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Actions
    
    //MARK: - Helpers
    
    //MARK: - UI
    
    private func configureUI() {
        configureMapView()
    }
    
    private func configureMapView() {
        view.addSubview(mapView)
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setPinUsingMKAnnotation(pinables: [Pinable]) {
        pinables.forEach { pinable in
            let pin1 = MapPin(pinable: pinable)
            mapView.addAnnotations([pin1])
            
        }
    }
    
    private func centerViewOnUserLocation() {
        
        guard let location = locationManager.fetchLocation() else { return }
        
        let region = MKCoordinateRegion(center: location, latitudinalMeters: 10000, longitudinalMeters: 10000)
        
        mapView.setRegion(region, animated: true)
        
    }
}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        
                if annotation is MKClusterAnnotation {
                    //            let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "mapItem", for: annotation) as! MKAnnotationView
                    let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: ClusterAnnotationView.identifier, for: annotation) as! ClusterAnnotationView
                    let count = (annotation as! MKClusterAnnotation).memberAnnotations.count
                    annotationView.setTitle(count: count)
        
                    print(count)
        
                    return annotationView
                } else if annotation is MKUserLocation {
                    let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "user", for: annotation)
//                    annotationView.displayPriority = .defaultHigh
                    return annotationView
                } else {
                    let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: CustomAnnotationView.identifier, for: annotation) as! CustomAnnotationView
                    //            annotationView.clusteringIdentifier = String(describing: LocationDataMapAnnotationView.self)
        
                    
                    
                    Task {
                        do {
                            
                            let image = try await ImageLoader.fetchPhoto(urlString: (annotation as! MapPin).pinable.imageURL)
        
                            annotationView.setImage(image: image)
        
                        } catch {
                            print(error)
                        }
                    }
        
                    return annotationView
                }
            }
    
}
