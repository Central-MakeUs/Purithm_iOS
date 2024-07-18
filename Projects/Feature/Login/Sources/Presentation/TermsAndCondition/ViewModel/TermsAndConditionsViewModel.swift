//
//  TermsAndConditionsViewModel.swift
//  Login
//
//  Created by 이숭인 on 7/17/24.
//

import Foundation
import Combine
import CombineExt
import CoreListKit

extension TermsAndConditionsViewModel {
    struct Input {
        
    }
    
    struct Output {
        let sectionItems = CurrentValueSubject<[SectionModelType], Never>([])
    }
}

final class TermsAndConditionsViewModel {
    weak var coordinator: LoginCoordinator?
    private let converter = TermsAndConditionsViewSectionConverter()
    
    
    
    init(coordinator: LoginCoordinator) {
        self.coordinator = coordinator
    }
    
    func transform() -> Output {
        let output = Output()
        let sections = converter.createSections(
            notice: "공지다 공지다 공지다 공지다 공지다 공지다 공지다 공지다 공지다 공지다 공지다 공지다 공지다 공지다 공지다 공지다 공지다 공지다 공지다 공지다 공지다 공지다 공지다 공지다",
            items: ["", ""]
        )
        
        output.sectionItems.send(sections)
        
        return output
    }
    
    func testFinish() {
        coordinator?.finish()
    }
}
