//
//  FoundResponseDTOMapper.swift
//  FenceApp
//
//  Created by Woojun Lee on 10/21/23.
//

import FirebaseFirestore

struct FoundResponseDTOMapper {
    
    static func makeFoundResponseDTOs(dictionary: [String: Any]) -> FoundResponseDTO {
        
        FoundResponseDTO(latitude: dictionary[FB.Found.latitude] as? Double ?? 0,
                         longitude: dictionary[FB.Found.longitude] as? Double ?? 0,
                         imageURL: dictionary[FB.Found.imageURL] as? String ?? "",
                         date: (dictionary[FB.Found.date] as? Timestamp)?.dateValue() ?? Date(),
                         userIdentifier: dictionary[FB.Found.userIdentifier] as? String ?? "",
                         foundIdentifier: dictionary[FB.Found.foundIdentifier] as? String ?? "")
    }
    
    static func makeFoundResponseDTOs(dictionaries: [[String: Any]]) -> [FoundResponseDTO] {
        
        return dictionaries.map { dictionary in
            makeFoundResponseDTOs(dictionary: dictionary)
        }
    }
    
    static func makeDictionary(foundResponseDTO: FoundResponseDTO) -> [String: Any] {
        
        let data: [String: Any] = [FB.Found.latitude: foundResponseDTO.latitude,
                                   FB.Found.longitude: foundResponseDTO.longitude,
                                   FB.Found.imageURL: foundResponseDTO.imageURL,
                                   FB.Found.date: foundResponseDTO.date,
                                   FB.Found.userIdentifier: foundResponseDTO.userIdentifier,
                                   FB.Found.foundIdentifier: foundResponseDTO.foundIdentifier]
        
        return data
    }
}
