//
//  DummyCreator.swift
//  FenceApp
//
//  Created by Woojun Lee on 10/23/23.
//

import Foundation

// 나중에 혹시나 더미 데이터 파이어베이스 다시 저장해야할때를 위해 남겨둠

//Task {
//    do {
//        let user1 = UserResponseDTO.dummyUser[0]
//        let user2 = UserResponseDTO.dummyUser[1]
//        let user3 = UserResponseDTO.dummyUser[2]
//        let user4 = UserResponseDTO.dummyUser[3]
//        let user5 = UserResponseDTO.dummyUser[4]
//        
//        let imageLoader = ImageLoader()
//        
//        let profileImage1 = try await imageLoader.fetchPhoto(urlString: user1.profileImageURL)
//        let profileImage2 = try await imageLoader.fetchPhoto(urlString: user2.profileImageURL)
//        let profileImage3 = try await imageLoader.fetchPhoto(urlString: user3.profileImageURL)
//        let profileImage4 = try await imageLoader.fetchPhoto(urlString: user4.profileImageURL)
//        let profileImage5 = try await imageLoader.fetchPhoto(urlString: user5.profileImageURL)
//        
//        let  profileUrl1 = try await firebaseImageUploadService.uploadProfileImage(image: profileImage1)
//        let  profileUrl2 = try await firebaseImageUploadService.uploadProfileImage(image: profileImage2)
//        let  profileUrl3 = try await firebaseImageUploadService.uploadProfileImage(image: profileImage3)
//        let  profileUrl4 = try await firebaseImageUploadService.uploadProfileImage(image: profileImage4)
//        let  profileUrl5 = try await firebaseImageUploadService.uploadProfileImage(image: profileImage5)
//        
//        let userResponseDTO1 = UserResponseDTO(email: user1.email, profileImageURL: profileUrl1, identifier: user1.identifier, nickname: user1.nickname)
//        let userResponseDTO2 = UserResponseDTO(email: user2.email, profileImageURL: profileUrl2, identifier: user2.identifier, nickname: user2.nickname)
//        let userResponseDTO3 = UserResponseDTO(email: user3.email, profileImageURL: profileUrl3, identifier: user3.identifier, nickname: user3.nickname)
//        let userResponseDTO4 = UserResponseDTO(email: user4.email, profileImageURL: profileUrl4, identifier: user4.identifier, nickname: user4.nickname)
//        let userResponseDTO5 = UserResponseDTO(email: user5.email, profileImageURL: profileUrl5, identifier: user5.identifier, nickname: user5.nickname)
//        
//        try await firebaseUserService.createUser(userResponseDTO: userResponseDTO1)
//        try await firebaseUserService.createUser(userResponseDTO: userResponseDTO2)
//        try await firebaseUserService.createUser(userResponseDTO: userResponseDTO3)
//        try await firebaseUserService.createUser(userResponseDTO: userResponseDTO4)
//        try await firebaseUserService.createUser(userResponseDTO: userResponseDTO5)
//        
//        
//        
//        
//        let lostImage1 = try await imageLoader.fetchPhoto(urlString: "https://img.freepik.com/free-photo/isolated-happy-smiling-dog-white-background-portrait-4_1562-693.jpg")
//        let lostImage2 = try await imageLoader.fetchPhoto(urlString: "https://i.natgeofe.com/n/4f5aaece-3300-41a4-b2a8-ed2708a0a27c/domestic-dog_thumb_3x2.jpg")
//        let lostImage3 = try await imageLoader.fetchPhoto(urlString: "https://images.pexels.com/photos/2607544/pexels-photo-2607544.jpeg?cs=srgb&dl=pexels-simona-kidri%C4%8D-2607544.jpg&fm=jpg")
//        let lostImage4 = try await imageLoader.fetchPhoto(urlString: "https://cdn.salgoonews.com/news/photo/202105/2904_7323_220.jpg")
//        let lostImage5 = try await imageLoader.fetchPhoto(urlString: "https://www.fitpetmall.com/wp-content/uploads/2023/02/CK_tc02730000546-edited-scaled.jpg")
//        
//        let lostUrl1 = try await firebaseImageUploadService.uploadLostImage(image: lostImage1)
//        let lostUrl2 = try await firebaseImageUploadService.uploadLostImage(image: lostImage2)
//        let lostUrl3 = try await firebaseImageUploadService.uploadLostImage(image: lostImage3)
//        let lostUrl4 = try await firebaseImageUploadService.uploadLostImage(image: lostImage4)
//        let lostUrl5 = try await firebaseImageUploadService.uploadLostImage(image: lostImage5)
//        
//        var lostResponseDTO1 = LostResponseDTO.dummyLost[0]
//        var lostResponseDTO2 = LostResponseDTO.dummyLost[1]
//        var lostResponseDTO3 = LostResponseDTO.dummyLost[2]
//        var lostResponseDTO4 = LostResponseDTO.dummyLost[3]
//        var lostResponseDTO5 = LostResponseDTO.dummyLost[4]
//        
//        lostResponseDTO1.pictureURL = lostUrl1
//        lostResponseDTO2.pictureURL = lostUrl2
//        lostResponseDTO3.pictureURL = lostUrl3
//        lostResponseDTO4.pictureURL = lostUrl4
//        lostResponseDTO5.pictureURL = lostUrl5
//        
//        try await firebaseLostService.createLost(lostResponseDTO: lostResponseDTO1)
//        try await firebaseLostService.createLost(lostResponseDTO: lostResponseDTO2)
//        try await firebaseLostService.createLost(lostResponseDTO: lostResponseDTO3)
//        try await firebaseLostService.createLost(lostResponseDTO: lostResponseDTO4)
//        try await firebaseLostService.createLost(lostResponseDTO: lostResponseDTO5)
//        
//        let foundImage1 = try await imageLoader.fetchPhoto(urlString: "https://blog.kakaocdn.net/dn/l3nYw/btq0pwrPxwK/1SrUH9SL8Ijjtd3JYr3Dr1/img.jpg")
//        let foundImage2 = try await imageLoader.fetchPhoto(urlString: "https://blog.kakaocdn.net/dn/bHMBgc/btqzfFiNJrC/6cwv9ckq37x5qKsmKwkFg1/img.jpg")
//        let foundImage3 = try await imageLoader.fetchPhoto(urlString: "https://mblogthumb-phinf.pstatic.net/MjAyMTAyMTRfMTA5/MDAxNjEzMjg3MDUzNzkz.wZSobWsO3288JabgK70kRDzY0MaAbMhQ9vvmX047ty8g.JE7vozp7bz_z9X1hUWBr0CywxfWqJrOLSFMxqC2gGm4g.JPEG.qlsqls0203/output_1990378801.jpg?type=w800")
//        let foundImage4 = try await imageLoader.fetchPhoto(urlString: "https://d2v80xjmx68n4w.cloudfront.net/gigs/9Ul5L1690523558.jpg")
//        let foundImage5 = try await imageLoader.fetchPhoto(urlString: "https://d1bg8rd1h4dvdb.cloudfront.net/upload/imgServer/storypick/editor/2020062615503065168.jpg")
//        
//        let foundUrl1 = try await firebaseImageUploadService.uploadeFoundImage(image: foundImage1)
//        let foundUrl2 = try await firebaseImageUploadService.uploadeFoundImage(image: foundImage2)
//        let foundUrl3 = try await firebaseImageUploadService.uploadeFoundImage(image: foundImage3)
//        let foundUrl4 = try await firebaseImageUploadService.uploadeFoundImage(image: foundImage4)
//        let foundUrl5 = try await firebaseImageUploadService.uploadeFoundImage(image: foundImage5)
//        
//        let foundResponseDTO1Reference = FoundResponseDTO.dummyFoundDTO[0]
//        let foundResponseDTO2Reference = FoundResponseDTO.dummyFoundDTO[1]
//        let foundResponseDTO3Reference = FoundResponseDTO.dummyFoundDTO[2]
//        let foundResponseDTO4Reference = FoundResponseDTO.dummyFoundDTO[3]
//        let foundResponseDTO5Reference = FoundResponseDTO.dummyFoundDTO[4]
//        
//        
//        let foundResponseDTO1 = FoundResponseDTO(latitude: foundResponseDTO1Reference.latitude, longitude: foundResponseDTO1Reference.longitude, imageURL: foundUrl1, date: foundResponseDTO1Reference.date, userIdentifier: foundResponseDTO1Reference.userIdentifier, foundIdentifier: foundResponseDTO1Reference.foundIdentifier)
//        
//        let foundResponseDTO2 = FoundResponseDTO(latitude: foundResponseDTO2Reference.latitude, longitude: foundResponseDTO2Reference.longitude, imageURL: foundUrl2, date: foundResponseDTO2Reference.date, userIdentifier: foundResponseDTO2Reference.userIdentifier, foundIdentifier: foundResponseDTO2Reference.foundIdentifier)
//        
//        let foundResponseDTO3 = FoundResponseDTO(latitude: foundResponseDTO3Reference.latitude, longitude: foundResponseDTO3Reference.longitude, imageURL: foundUrl3, date: foundResponseDTO3Reference.date, userIdentifier: foundResponseDTO3Reference.userIdentifier, foundIdentifier: foundResponseDTO3Reference.foundIdentifier)
//        
//        let foundResponseDTO4 = FoundResponseDTO(latitude: foundResponseDTO4Reference.latitude, longitude: foundResponseDTO4Reference.longitude, imageURL: foundUrl4, date: foundResponseDTO4Reference.date, userIdentifier: foundResponseDTO4Reference.userIdentifier, foundIdentifier: foundResponseDTO4Reference.foundIdentifier)
//        
//        let foundResponseDTO5 = FoundResponseDTO(latitude: foundResponseDTO5Reference.latitude, longitude: foundResponseDTO5Reference.longitude, imageURL: foundUrl5, date: foundResponseDTO5Reference.date, userIdentifier: foundResponseDTO5Reference.userIdentifier, foundIdentifier: foundResponseDTO5Reference.foundIdentifier)
//        
//        
//        try await firebaseFoundService.createFound(foundResponseDTO: foundResponseDTO1)
//        try await firebaseFoundService.createFound(foundResponseDTO: foundResponseDTO2)
//        try await firebaseFoundService.createFound(foundResponseDTO: foundResponseDTO3)
//        try await firebaseFoundService.createFound(foundResponseDTO: foundResponseDTO4)
//        try await firebaseFoundService.createFound(foundResponseDTO: foundResponseDTO5)
//        
//        let dummyComments = CommentResponseDTO.dummyComment
//        
//        for comment in dummyComments {
//            try await firebaseLostCommentService.createComment(commentResponseDTO: comment)
//        }
//        
//        
//        
//        
//        
//    } catch {
//        print(error, "@@@@@@@@")
//    }
//}



