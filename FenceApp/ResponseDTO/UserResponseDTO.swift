//
//  UserDTO.swift
//  FenceApp
//
//  Created by Woojun Lee on 10/19/23.
//

import UIKit



struct UserResponseDTO {
    
    let email: String
    var profileImageURL: String
    let identifier: String
    var nickname: String
    
    static var dummyUser: [UserResponseDTO] = [
        UserResponseDTO(email: "aaa@gmail.com",profileImageURL: "https://i.pinimg.com/1200x/2c/2c/60/2c2c60b20cb817a80afd381ae23dab05.jpg", identifier: "t8lGZWXAJvOkNT3fKtEdVSFbJ7c2", nickname: "user1"),
        UserResponseDTO(email: "bbb@gmail.com",profileImageURL: "https://biz.chosun.com/resizer/CSzzWDpK-XmTF_MKD5PZ43dHI8U=/530x662/smart/cloudfront-ap-northeast-1.images.arcpublishing.com/chosunbiz/VFK4J3A7JYKU6YW25IPOHLMWUY.jpg", identifier: "045RhOisSFgjp0AjR2DusTpDsyb2", nickname: "user2"),
        UserResponseDTO(email: "ccc@gmail.com",profileImageURL: "https://mblogthumb-phinf.pstatic.net/MjAxNzAyMTJfNzYg/MDAxNDg2ODI3OTI0MzU3.AcuS1ZBkN9YjL0sJVrKKie8YQxuyczNxjWFeCjSWsPIg.WCCpi1pDNq4LT02Uob6F-fOQQBxeekEICsQv0Tz0v2gg.JPEG.jejuwg/%EB%B0%B0%EC%9A%B0%ED%94%84%EB%A1%9C%ED%95%84%EC%82%AC%EC%A7%84_DSC_7014.jpg?type=w800", identifier: "uL1EmjrRjCdUeaFNwXWzbXGTW0H3", nickname: "user3"),
        UserResponseDTO(email: "ddd@gmail.com",profileImageURL: "https://image.fnnews.com/resource/media/image/2021/08/13/202108131238497606_l.jpg", identifier: "yHxBDaHDNpNGfE6XcPxmC2gdXZk1", nickname: "user4"),
        UserResponseDTO(email: "eee@gmail.com",profileImageURL: "https://file.mk.co.kr/meet/neds/2022/08/image_readtop_2022_727059_16607099995139757.jpg", identifier: "W8fVgEGBNuSpvOGBK9Z3mPKp6a33", nickname: "user5"),
    ]
    
    
}
