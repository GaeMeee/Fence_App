//
//  LostResponseDTOMapper.swift
//  FenceApp
//
//  Created by Woojun Lee on 10/21/23.
//


import FirebaseFirestore

struct LostResponseDTOMapper {
    
    static func makeLostResponseDTO(from dictionary: [String: Any]) -> LostResponseDTO {
        
        return LostResponseDTO(lostIdentifier: dictionary[FB.Lost.lostIdentifier] as? String ?? "",
                               latitude: dictionary[FB.Lost.latitude] as? Double ?? 0,
                               longitude: dictionary[FB.Lost.longitude] as? Double ?? 0,
                               userIdentifier: dictionary[FB.Lost.userIdentifier] as? String ?? "",
                               userProfileImageURL: dictionary[FB.Lost.userProfileImageURL] as? String ?? "",
                               userNickName: dictionary[FB.Lost.userNickName] as? String ?? "",
                               title: dictionary[FB.Lost.title] as? String ?? "",
                               postDate: (dictionary[FB.Lost.postDate] as? Timestamp)?.dateValue() ?? Date(),
                               lostDate: (dictionary[FB.Lost.lostDate] as? Timestamp)?.dateValue() ?? Date(),
                               pictureURL: dictionary[FB.Lost.pictureURL] as? String ?? "",
                               petName: dictionary[FB.Lost.petName] as? String ?? "",
                               description: dictionary[FB.Lost.lostDescription] as? String ?? "",
                               kind: dictionary[FB.Lost.kind] as? String ?? "")
    }
    
    static func makeLostResponseDTOs(from dictionaries: [[String: Any]]) -> [LostResponseDTO] {
        
        return dictionaries.map { dictionary in
            makeLostResponseDTO(from: dictionary)
        }
    }
    
    static func makeDictionary(from lostResponseDTO: LostResponseDTO) -> [String: Any] {
        
        let data: [String: Any] = [FB.Lost.lostIdentifier: lostResponseDTO.lostIdentifier,
                                   FB.Lost.latitude: lostResponseDTO.latitude,
                                   FB.Lost.longitude: lostResponseDTO.longitude,
                                   FB.Lost.userIdentifier: lostResponseDTO.userIdentifier,
                                   FB.Lost.userProfileImageURL: lostResponseDTO.userProfileImageURL,
                                   FB.Lost.userNickName: lostResponseDTO.userNickName,
                                   FB.Lost.title: lostResponseDTO.title,
                                   FB.Lost.postDate: Timestamp(date: lostResponseDTO.postDate),
                                   FB.Lost.lostDate: Timestamp(date: lostResponseDTO.lostDate),
                                   FB.Lost.pictureURL: lostResponseDTO.imageURL,
                                   FB.Lost.petName: lostResponseDTO.petName,
                                   FB.Lost.lostDescription: lostResponseDTO.description,
                                   FB.Lost.kind: lostResponseDTO.kind]
        
        return data
    }
}



