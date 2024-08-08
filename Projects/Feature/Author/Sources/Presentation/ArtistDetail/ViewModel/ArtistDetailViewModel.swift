//
//  ArtistDetailViewModel.swift
//  Author
//
//  Created by 이숭인 on 8/9/24.
//

import Foundation
import Combine
import CoreUIKit

final class ArtistDetailViewModel {
    weak var coordinator: ArtistCoordinatorable?
    
    init(coordinator: ArtistCoordinatorable) {
        self.coordinator = coordinator
    }
}
