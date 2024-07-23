//
//  TermsAndConditionsViewModel.swift
//  Login
//
//  Created by 이숭인 on 7/17/24.
//

import Foundation
import Combine
import CombineExt
import CoreUIKit

/// 동의항목
enum ConsentItemType: String, CaseIterable {
    case termsOfService = "(필수) 서비스 이용약관"
    case marketingEmails = "(선택) 마케팅 정보 수신 동의"
}

struct ConsentItem: Hashable {
    let identifier: String
    let type: ConsentItemType
    var isSelected: Bool
}

extension TermsAndConditionsViewModel {
    struct Input {
        let termsButtonDidTapEvent: AnyPublisher<ItemModelType, Never>
    }
    
    struct Output {
        let sectionItems = CurrentValueSubject<[SectionModelType], Never>([])
    }
}

final class TermsAndConditionsViewModel {
    weak var coordinator: LoginCoordinator?
    private let converter = TermsAndConditionsViewSectionConverter()
    var cancellables = Set<AnyCancellable>()
    
    var consentItems: [ConsentItem] = ConsentItemType.allCases.map { type in
        ConsentItem(identifier: UUID().uuidString, type: type, isSelected: false)
    }
    
    init(coordinator: LoginCoordinator) {
        self.coordinator = coordinator
        
    }
    
    private func selectConsentItem(identifier: String) {
        if let targetIndex = consentItems.firstIndex(where: { $0.identifier == identifier }) {
            consentItems[targetIndex].isSelected.toggle()
        }
    }
    
    func transform(input: Input) -> Output {
        let output = Output()
        
        input.termsButtonDidTapEvent
            .receive(on: DispatchQueue.main)
            .sink { [weak self] itemModel in
                guard let self else { return }
                self.selectConsentItem(identifier: itemModel.identifier)
                let sections = converter.createSections(
                    notice: "퓨리즘의 서비스 약관입니다. 필수 약관을 동의하셔야 이용하실 수 있습니다.",
                    items: self.consentItems
                )
                
                output.sectionItems.send(sections)
            }
            .store(in: &cancellables)
        
        let sections = converter.createSections(
            notice: "퓨리즘의 서비스 약관입니다. 필수 약관을 동의하셔야 이용하실 수 있습니다.",
            items: consentItems
        )
        
        output.sectionItems.send(sections)
        
        return output
    }
    
    func testFinish() {
        coordinator?.finish()
    }
}
