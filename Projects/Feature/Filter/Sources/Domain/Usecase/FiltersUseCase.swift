//
//  FiltersUseCase.swift
//  Filter
//
//  Created by 이숭인 on 8/5/24.
//

import Foundation
import Combine

public protocol FiltersServiceManageable {

}


final class FiltersUseCase {
    private var cancellables = Set<AnyCancellable>()
    
//    private let repository: AuthRepository
    private let authService: FiltersServiceManageable
    
    init(authService: FiltersServiceManageable) {
        self.authService = authService
    }
}
