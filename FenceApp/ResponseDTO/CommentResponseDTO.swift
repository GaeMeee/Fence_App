//
//  CommentDTO.swift
//  FenceApp
//
//  Created by Woojun Lee on 10/19/23.
//

import Foundation


struct CommentResponseDTO {
    
    let lostIdentifier: String
    let commentIdentifier: String
    let userIdentifier: String
    var userProfileImageURL: String
    var userNickname: String
    var commentDescription: String
    let commentDate: Date
    
    
    
    /// 얘는 받아올때 쓰는용도
    
    init(lostIdentifier: String, commentIdentifier: String = UUID().uuidString, userIdentifier: String, userProfileImageURL: String, userNickname: String, commentDescription: String, commentDate: Date) {
        self.lostIdentifier = lostIdentifier
        self.commentIdentifier = commentIdentifier
        self.userIdentifier = userIdentifier
        self.userProfileImageURL = userProfileImageURL
        self.userNickname = userNickname
        self.commentDescription = commentDescription
        self.commentDate = commentDate
    }
    
    /// 저장할때 쓰는용도
    init(lostIdentifier: String, userIdentifier: String, userProfileImageURL: String, userNickname: String, commentDescription: String, commentDate: Date) {
        
        self.commentIdentifier = UUID().uuidString
        self.lostIdentifier = lostIdentifier
        self.userIdentifier = userIdentifier
        self.userProfileImageURL = userProfileImageURL
        self.userNickname = userNickname
        self.commentDescription = commentDescription
        self.commentDate = commentDate
    }
    
   
    
    static var dummyComment: [CommentResponseDTO] = [
        
        CommentResponseDTO(lostIdentifier: LostResponseDTO.dummyLost[0].lostIdentifier, userIdentifier: UserResponseDTO.dummyUser[0].identifier, userProfileImageURL: UserResponseDTO.dummyUser[0].profileImageURL, userNickname: UserResponseDTO.dummyUser[0].nickname, commentDescription: "description1", commentDate: Calendar.current.date(byAdding: .day, value: 0, to: Date())!),
        
        CommentResponseDTO(lostIdentifier: LostResponseDTO.dummyLost[1].lostIdentifier, userIdentifier: UserResponseDTO.dummyUser[1].identifier, userProfileImageURL: UserResponseDTO.dummyUser[1].profileImageURL, userNickname: UserResponseDTO.dummyUser[1].nickname, commentDescription: "description1", commentDate: Calendar.current.date(byAdding: .day, value: -1, to: Date())!),
        
        CommentResponseDTO(lostIdentifier: LostResponseDTO.dummyLost[2].lostIdentifier, userIdentifier: UserResponseDTO.dummyUser[2].identifier, userProfileImageURL: UserResponseDTO.dummyUser[2].profileImageURL, userNickname: UserResponseDTO.dummyUser[2].nickname, commentDescription: "description1", commentDate: Calendar.current.date(byAdding: .day, value: -2, to: Date())!),
        
        CommentResponseDTO(lostIdentifier: LostResponseDTO.dummyLost[3].lostIdentifier, userIdentifier: UserResponseDTO.dummyUser[3].identifier, userProfileImageURL: UserResponseDTO.dummyUser[3].profileImageURL, userNickname: UserResponseDTO.dummyUser[3].nickname, commentDescription: "description1", commentDate: Calendar.current.date(byAdding: .day, value: -3, to: Date())!),
        
        CommentResponseDTO(lostIdentifier: LostResponseDTO.dummyLost[4].lostIdentifier, userIdentifier: UserResponseDTO.dummyUser[4].identifier, userProfileImageURL: UserResponseDTO.dummyUser[4].profileImageURL, userNickname: UserResponseDTO.dummyUser[4].nickname, commentDescription: "description1", commentDate: Calendar.current.date(byAdding: .day, value: -4, to: Date())!),
        
    ]
}
