//
//  UserMapper.swift
//  FenceApp
//
//  Created by Woojun Lee on 10/21/23.
//

struct UserResponseDTOMapper {
    
    static func makeUserResponseDTO(from dictionary: [String: Any]) -> UserResponseDTO {
        
        UserResponseDTO(email: dictionary[FB.User.email] as? String ?? "",
                        profileImageURL: dictionary[FB.User.userNickname] as? String ?? "",
                        identifier: dictionary[FB.User.profileImageURL] as? String ?? "",
                        nickname: dictionary[FB.User.useridentifier] as? String ?? "")
    }
    
    static func makeUserResponseDTOs(from dictionaries: [[String: Any]]) -> [UserResponseDTO] {
        return dictionaries.map { dictionary in
            makeUserResponseDTO(from: dictionary)
        }
    }
    
    static func makeDictionary(from userResponseDTO: UserResponseDTO) -> [String: Any] {
        
        let data: [String: Any] = [FB.User.email: userResponseDTO.email,
                                   FB.User.userNickname: userResponseDTO.nickname,
                                   FB.User.profileImageURL: userResponseDTO.profileImageURL,
                                   FB.User.useridentifier: userResponseDTO.identifier]
        
        return data
        
    }
}

