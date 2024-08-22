//
//  ProfileMyWishlistResponseDTO.swift
//  Profile
//
//  Created by 이숭인 on 8/22/24.
//

import Foundation

public struct ProfileMyWishlistResponseDTO: Codable {
    let id: Int
    let membership: String
    let name: String
    let thumbnail: String
    let photographerName: String
    let likes: Int
    let canAccess: Bool
    
    public init(id: Int, membership: String, name: String, thumbnail: String, photographerName: String, likes: Int, canAccess: Bool) {
        self.id = id
        self.membership = membership
        self.name = name
        self.thumbnail = thumbnail
        self.photographerName = photographerName
        self.likes = likes
        self.canAccess = canAccess
    }
}
