//
//  FirebaseImageUploader.swift
//  FenceApp
//
//  Created by Woojun Lee on 10/18/23.
//

import UIKit

struct FirebaseImageUploadService {
    
    
    static func uploadProfileImage(image: UIImage) async throws -> String {
        
        guard let imageData = image.jpegData(compressionQuality: 0.75) else { throw PetError.invalidImage }
        
        let fileName = UUID().uuidString
        
        let ref = IMAGE_STORAGE.reference(withPath: "/profile_images/\(fileName)")
        
        let _ = try await ref.putDataAsync(imageData)
        
        let urlString = try await ref.downloadURL().absoluteString
        
        return urlString
    }
    
    
    static func uploadLostImage(image: UIImage) async throws -> String {
        
        guard let imageData = image.jpegData(compressionQuality: 0.75) else { throw PetError.invalidImage }
        
        let fileName = UUID().uuidString
        
        let ref = IMAGE_STORAGE.reference(withPath: "/lost_images/\(fileName)")
        
        let _ = try await ref.putDataAsync(imageData)
        
        let urlString = try await ref.downloadURL().absoluteString
        
        return urlString
    }
    
    
    static func uploadeFoundImage(image: UIImage) async throws -> String {
        
        guard let imageData = image.jpegData(compressionQuality: 0.75) else { throw PetError.invalidImage }
        
        let fileName = UUID().uuidString
        
        let ref = IMAGE_STORAGE.reference(withPath: "/found_images/\(fileName)")
        
        let _ = try await ref.putDataAsync(imageData)
        
        let urlString = try await ref.downloadURL().absoluteString
        
        return urlString
    }
    
}
