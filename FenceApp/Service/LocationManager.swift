//
//  LocationManager.swift
//  FenceApp
//
//  Created by Woojun Lee on 10/24/23.
//

import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        return manager
    }()
    
    override init() {
        super.init()
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func fetchLocation() -> CLLocationCoordinate2D? {
        locationManager.location?.coordinate
    }
    
    
//    func fetchLocation(completion: @escaping FetchLocationCompletion) {
//        self.requestLocation()
//        // completion 동작을 didFetchLocation 동작에 담는다.
//        self.fetchLocationCompletion = completion
//    }
//    
//    func fetchLocation
    
    //    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) -> String {
    //        <#code#>
    //    }
    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let location = locations.first
//    }
    
    //    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) -> String {
    //        var urlString = ""
    //        if let location = locations.first {
    //            // 위도와 경도 가져오기
    //            let latitude = location.coordinate.latitude
    //            let longitude = location.coordinate.longitude
    //
    //            // OpenWeatherMap API 요청 URL 생성
    //            urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(WeatherAPIService().apiKey)"
    //        }
    //        return urlString
    //    }
}
