//
//  ArtistCoordinatorable.swift
//  Author
//
//  Created by 이숭인 on 8/8/24.
//

import Foundation
import CoreCommonKit

protocol ArtistCoordinatorable: Coordinator { 
    func pushArtistDetail(with artistID: String)
    
    func pushFilterDetail(with filterID: String)
}
