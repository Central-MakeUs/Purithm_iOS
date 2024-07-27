//
//  TermsAndConditionsViewSectionConverter.swift
//  Login
//
//  Created by 이숭인 on 7/18/24.
//

import Foundation
import CoreUIKit

final class TermsAndConditionsViewSectionConverter {
    func createSections(notice: String, items: [ConsentItem]) -> [SectionModelType] {
        [
            createNoticeSection(with: notice),
            createEmptySpacingSection(),
            createAgreementItemsSection(with: items)
        ].flatMap { $0 }
    }
}

//MARK: Notice
extension TermsAndConditionsViewSectionConverter {
    private func createNoticeSection(with notice: String) -> [SectionModelType] {
        let noticeComponent = TermsNoticeComponent(
            identifier: notice, //TODO: 바꿔야함!! 이것도 모델로 만들어여함!!
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
    private func createAgreementItemsSection(with items: [ConsentItem]) -> [SectionModelType] {
        let itemComponents = items.map { item in
            TermsAndConditionItemComponent(identifier: item.identifier, type: item.type, isSelected: item.isSelected)
        }
        
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

// MARK: - EmptySpacing
extension TermsAndConditionsViewSectionConverter {
    private func createEmptySpacingSection() -> [SectionModelType] {
        let emptySpacingComponent = EmptySpacingComponent(
            identifier: "empty_spacing",
            height: 40
        )
        
        let section = SectionModel(
            identifier: "empty_spacing_section_one",
            collectionLayout: createEmptySpacingCollectionLayout(),
            itemModels: [emptySpacingComponent]
        )
        
        return [section]
    }
    
    private func createEmptySpacingCollectionLayout() -> CompositionalLayoutModelType {
        CompositionalLayoutModel(
            itemStrategy: .item(widthDimension: .fractionalWidth(1.0),
                                heightDimension: .absolute(40)),
            groupStrategy: .item(widthDimension: .fractionalWidth(1.0),
                                 heightDimension: .absolute(40)),
            scrollBehavior: .none
        )
    }
}
