//
//  CommentResponseDTOMapper.swift
//  FenceApp
//
//  Created by Woojun Lee on 10/21/23.
//

import FirebaseFirestore

struct CommentResponseDTOMapper {
    
    static func makeCommentResponseDTO(dictionary: [String: Any]) -> CommentResponseDTO {
        CommentResponseDTO(lostIdentifier: dictionary[FB.Comment.lostIdentifier] as? String ?? "",
                           commentIdentifier: dictionary[FB.Comment.commentIdentifier] as? String ?? "",
                           userIdentifier: dictionary[FB.Comment.userIdentifier] as? String ?? "",
                           userProfileImageURL: dictionary[FB.Comment.userProfileImageURL] as? String ?? "",
                           userNickname: dictionary[FB.Comment.userNickname] as? String ?? "",
                           commentDescription: dictionary[FB.Comment.commentDescription] as? String ?? "",
                           commentDate: (dictionary[FB.Comment.commentDate] as? Timestamp)?.dateValue() ?? Date())
    }
    
    static func makeCommentResponseDTOs(dictionaries: [[String: Any]]) -> [CommentResponseDTO] {
        
        return dictionaries.map { dictionary in
            makeCommentResponseDTO(dictionary: dictionary)
        }
    }
    
    static func makeDictionary(commentResponseDTO: CommentResponseDTO) -> [String: Any] {
        
        let data: [String: Any] = [FB.Comment.lostIdentifier: commentResponseDTO.lostIdentifier,
                                   FB.Comment.commentIdentifier: commentResponseDTO.commentIdentifier,
                                   FB.Comment.userIdentifier: commentResponseDTO.userIdentifier,
                                   FB.Comment.userProfileImageURL: commentResponseDTO.userProfileImageURL,
                                   FB.Comment.userNickname: commentResponseDTO.userNickname,
                                   FB.Comment.commentDescription: commentResponseDTO.commentDescription,
                                   FB.Comment.commentDate: commentResponseDTO.commentDate]
        
        return data
    }
}



