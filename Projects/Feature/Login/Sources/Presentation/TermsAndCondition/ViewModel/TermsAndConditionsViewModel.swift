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
import UIKit
import CorePurithmAuth

/// 동의항목
enum ConsentItemType: String, CaseIterable {
    case termsOfService = "(필수) 서비스 이용약관"
}

struct ConsentItem: Hashable {
    let identifier: String
    let type: ConsentItemType
    var isSelected: Bool
}

extension TermsAndConditionsViewModel {
    struct Input {
        let viewWillAppearEvent: AnyPublisher<Bool, Never>
        let termsItemDidTapEvent: AnyPublisher<ItemModelType, Never>
        let navigateTermsOfServiceEvent: AnyPublisher<ActionEventItem, Never>
        let endOfAgreeEvent: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let sectionItems = CurrentValueSubject<[SectionModelType], Never>([])
        let canProceed = PassthroughSubject<Bool, Never>()
    }
}

final class TermsAndConditionsViewModel {
    weak var coordinator: LoginCoordinatorable?
    private let converter = TermsAndConditionsViewSectionConverter()
    var cancellables = Set<AnyCancellable>()
    private weak var useCase: SignInUseCase?
    
    private let errorSubject = PassthroughSubject<Error, Never>()
    var errorPublisher: AnyPublisher<Error, Never> {
        errorSubject.eraseToAnyPublisher()
    }
    
    var consentItems: [ConsentItem] = ConsentItemType.allCases.map { type in
        ConsentItem(identifier: UUID().uuidString, type: type, isSelected: false)
    }
    
    init(coordinator: LoginCoordinatorable, useCase: SignInUseCase) {
        self.coordinator = coordinator
        self.useCase = useCase
        
    }
    
    func transform(input: Input) -> Output {
        let output = Output()
        
        handleViewWillAppearEvent(input: input, output: output)
        handleTermsItemDidTapEvent(input: input, output: output)
        handleNavigateTermsOfServiceEvent(input: input)
        handleEndOfAgreeEvent(input: input)
        
        return output
    }
}

// MARK: - Convert Sections
extension TermsAndConditionsViewModel {
    private func handleViewWillAppearEvent(input: Input, output: Output) {
        input.viewWillAppearEvent
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.updateSectionsAndSendOutput(output: output)
            }
            .store(in: &cancellables)
    }
    
    private func handleTermsItemDidTapEvent(input: Input, output: Output) {
        input.termsItemDidTapEvent
            .receive(on: DispatchQueue.main)
            .sink { [weak self] itemModel in
                guard let self = self else { return }
                self.selectConsentItem(identifier: itemModel.identifier)
                self.updateSectionsAndSendOutput(output: output)
                
                let canProceed = !self.consentItems.contains { !$0.isSelected }
                output.canProceed.send(canProceed)
            }
            .store(in: &cancellables)
    }
    
    private func selectConsentItem(identifier: String) {
        if let targetIndex = consentItems.firstIndex(where: { $0.identifier == identifier }) {
            consentItems[targetIndex].isSelected.toggle()
        }
    }
    
    private func updateSectionsAndSendOutput(output: Output) {
        let sections = converter.createSections(
            notice: "퓨리즘의 서비스 약관입니다. 필수 약관을 동의하셔야 이용하실 수 있습니다.",
            items: consentItems
        )
        output.sectionItems.send(sections)
    }
}

// MARK: - Navigate
extension TermsAndConditionsViewModel {
    private func handleNavigateTermsOfServiceEvent(input: Input) {
        input.navigateTermsOfServiceEvent
            .receive(on: DispatchQueue.main)
            .sink { actionItem in
                switch actionItem {
                case _ as TermsAndConditionItemAction:
                    if let url = URL(string: "https://www.notion.so/798f1bf6c507421584861961deb173d6?pvs=4") {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                default:
                    break
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: - EndOfAgree
extension TermsAndConditionsViewModel {
    private func handleEndOfAgreeEvent(input: Input) {
        input.endOfAgreeEvent
            .sink { [weak self] _ in
                guard let self else { return }
                let publisher = self.useCase?.conformTerms().share().materialize()
                
                publisher?.values()
                    .sink { _ in
                        self.coordinator?.finish()
                    }
                    .store(in: &cancellables)
                
                publisher?.failures()
                    .sink { error in
                        self.errorSubject.send(error)
                    }
                    .store(in: &cancellables)
            }
            .store(in: &cancellables)
    }
}
