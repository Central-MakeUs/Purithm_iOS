//
//  TermsAndConditionsViewSectionConverter.swift
//  Login
//
//  Created by 이숭인 on 7/18/24.
//

import Foundation
import CoreListKit

final class TermsAndConditionsViewSectionConverter {
    func createSections(notice: String, items: [String]) -> [SectionModelType] {
        [
            createNoticeSection(with: notice),
            createAgreementItemsSection(with: items)
        ].flatMap { $0 }
    }
}

//MARK: Notice
extension TermsAndConditionsViewSectionConverter {
    private func createNoticeSection(with notice: String) -> [SectionModelType] {
        let noticeComponent = TermsNoticeComponent(
            identifier: UUID().uuidString,
            notice: notice
        )
        
        let section = SectionModel(
            identifier: "notice_section",
            collectionLayout: createNoticeCollectionLayout(),
            itemModels: [noticeComponent]
        )
        
        return [section]
    }
    
    private func createNoticeCollectionLayout() -> CompositionalLayoutModelType {
        CompositionalLayoutModel(
            itemStrategy: .item(widthDimension: .fractionalWidth(1.0),
                                heightDimension: .estimated(80)),
            groupStrategy: .group(widthDimension: .fractionalWidth(1.0),
                                  heightDimension: .estimated(80)),
            scrollBehavior: .none)
    }
}

//MARK: AgreementItems
extension TermsAndConditionsViewSectionConverter {
    private func createAgreementItemsSection(with items: [String]) -> [SectionModelType] {
        let itemComponents = [
            ItemComponent(identifier: UUID().uuidString),
            ItemComponent(identifier: UUID().uuidString)
        ]
        
        let section = SectionModel(
            identifier: "agreement_section",
            collectionLayout: createAgreementItemsCollectionLayout(),
            itemModels: itemComponents
        )
        
        return [section]
    }
    
    private func createAgreementItemsCollectionLayout() -> CompositionalLayoutModelType {
        CompositionalLayoutModel(
            itemStrategy: .item(widthDimension: .fractionalWidth(1.0),
                                heightDimension: .estimated(20)),
            groupStrategy: .group(widthDimension: .fractionalWidth(1.0),
                                  heightDimension: .estimated(20)),
            scrollBehavior: .none)
    }
}
