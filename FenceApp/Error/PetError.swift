//
//  PetError.swift
//  FenceApp
//
//  Created by Woojun Lee on 10/19/23.
//

import Foundation

enum PetError: Error {
    case invalidURL
    case invalidServerResponse
    case unsuppoertedImage
    case failTask
    case noData
    case invalidImage
    case noUser
    case noPictureInLost
    case noPictureURLInLost
    case noSnapshotDocument
    case noEmail
}
