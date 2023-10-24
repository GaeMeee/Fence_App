//
//  FoundDTO.swift
//  FenceApp
//
//  Created by Woojun Lee on 10/19/23.
//

import Foundation

struct FoundResponseDTO: Pinable {
    
    var latitude: Double
    var longitude: Double
    var imageURL: String
    let date: Date
    let userIdentifier: String
    let foundIdentifier: String
    
    init(latitude: Double, longitude: Double, imageURL: String, date: Date, userIdentifier: String, foundIdentifier: String) {
        self.latitude = latitude
        self.longitude = longitude
        self.imageURL = imageURL
        self.date = date
        self.userIdentifier = userIdentifier
        self.foundIdentifier = foundIdentifier
    }
    
    init(latitude: Double, longitude: Double, imageURL: String, date: Date, userIdentifier: String) {
        self.latitude = latitude
        self.longitude = longitude
        self.imageURL = imageURL
        self.date = date
        self.userIdentifier = userIdentifier
        self.foundIdentifier = UUID().uuidString
    }
   
    static var dummyFoundDTO: [FoundResponseDTO] = [
        FoundResponseDTO(latitude: 38.319562, longitude: 126.830221, imageURL: "https://blog.kakaocdn.net/dn/l3nYw/btq0pwrPxwK/1SrUH9SL8Ijjtd3JYr3Dr1/img.jpg", date: Calendar.current.date(byAdding: .day, value: 0, to: Date())!, userIdentifier: UserResponseDTO.dummyUser[0].identifier),
        FoundResponseDTO(latitude: 38.319228, longitude: 126.830198, imageURL: "https://blog.kakaocdn.net/dn/bHMBgc/btqzfFiNJrC/6cwv9ckq37x5qKsmKwkFg1/img.jpg", date: Calendar.current.date(byAdding: .day, value: -1, to: Date())!, userIdentifier: UserResponseDTO.dummyUser[1].identifier),
        FoundResponseDTO(latitude: 38.319203, longitude: 126.831058, imageURL: "https://mblogthumb-phinf.pstatic.net/MjAyMTAyMTRfMTA5/MDAxNjEzMjg3MDUzNzkz.wZSobWsO3288JabgK70kRDzY0MaAbMhQ9vvmX047ty8g.JE7vozp7bz_z9X1hUWBr0CywxfWqJrOLSFMxqC2gGm4g.JPEG.qlsqls0203/output_1990378801.jpg?type=w800", date: Calendar.current.date(byAdding: .day, value: -2, to: Date())!, userIdentifier: UserResponseDTO.dummyUser[2].identifier),
        FoundResponseDTO(latitude: 38.319552, longitude: 127.831137, imageURL: "https://d2v80xjmx68n4w.cloudfront.net/gigs/9Ul5L1690523558.jpg", date: Calendar.current.date(byAdding: .day, value: -3, to: Date())!, userIdentifier: UserResponseDTO.dummyUser[3].identifier),
        FoundResponseDTO(latitude: 38.319400, longitude: 126.830649, imageURL: "https://d1bg8rd1h4dvdb.cloudfront.net/upload/imgServer/storypick/editor/2020062615503065168.jpg", date: Calendar.current.date(byAdding: .day, value: -4, to: Date())!, userIdentifier: UserResponseDTO.dummyUser[4].identifier),
    ]
}
