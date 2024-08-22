//
//  ProfileEditRequestDTO.swift
//  Profile
//
//  Created by 이숭인 on 8/22/24.
//

import Foundation

public struct ProfileEditRequestDTO: Codable {
    let name: String
    let profile: String
    
    var toDictionary: [String: Any] {
        [
            "name": name,
            "profile": profile
        ]
    }
}
