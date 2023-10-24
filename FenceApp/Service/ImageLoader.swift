//
//  ImageLoader.swift
//  FenceApp
//
//  Created by Woojun Lee on 10/17/23.
//

import UIKit

struct ImageLoader {
    
    static func fetchPhoto(urlString: String) async throws -> UIImage {
        
        guard let url = URL(string: urlString) else { throw PetError.invalidURL }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else { throw PetError.invalidServerResponse }
        
        guard let image = UIImage(data: data) else { throw PetError.unsuppoertedImage }
        
        return image
    }
}
