//
//  TermsAndConditionsViewModel.swift
//  Login
//
//  Created by 이숭인 on 7/17/24.
//

import Foundation

final class TermsAndConditionsViewModel {
    weak var coordinator: LoginCoordinator?
    
    init(coordinator: LoginCoordinator) {
        self.coordinator = coordinator
    }
    
    func testFinish() {
        coordinator?.finish()
    }
}
