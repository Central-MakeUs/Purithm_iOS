//
//  ReviewSectionConverter.swift
//  Review
//
//  Created by 이숭인 on 8/9/24.
//

import Foundation
import CoreUIKit
import CoreCommonKit

final class ReviewSectionConverter {
    func createSections(headerModel: ReviewHeaderComponentModel) -> [SectionModelType] {
        [
            createHeaderSection(with: headerModel),
            createSliderSection(),
            createReviewContentSection(),
            createReviewImageContentSection(),
            createReviewTermsAgreementSection(),
            createReviewTermsItemSection(),
        ]
        .flatMap { $0 }
    }
}

//MARK: - Header
extension ReviewSectionConverter {
    private func createHeaderSection(with model: ReviewHeaderComponentModel) -> [SectionModelType] {
        let component = ReviewHeaderComponent(
            identifier: model.identifier,
            headerModel: model
        )
        
        let section = SectionModel(
            identifier: "header_section",
            collectionLayout: createHeaderCollectionLayout(),
            itemModels: [component]
        )
        
        return [section]
    }
    
    private func createHeaderCollectionLayout() -> CompositionalLayoutModelType {
        CompositionalLayoutModel(
            itemStrategy: .item(widthDimension: .fractionalWidth(1.0),
                                heightDimension: .absolute(220)),
            groupStrategy: .item(widthDimension: .fractionalWidth(1.0),
                                 heightDimension: .absolute(220)),
            scrollBehavior: .none
        )
    }
}

//MARK: - Slider
extension ReviewSectionConverter {
    private func createSliderSection() -> [SectionModelType] {
        let component = ReviewSliderComponent(identifier: UUID().uuidString)
        
        let section = SectionModel(
            identifier: "slider_section",
            collectionLayout: createSliderCollectionLayout(),
            itemModels: [component]
        )
        
        return [section]
    }
    
    private func createSliderCollectionLayout() -> CompositionalLayoutModelType {
        CompositionalLayoutModel(
            itemStrategy: .item(widthDimension: .fractionalWidth(1.0),
                                heightDimension: .absolute(32 + 40)),
            groupStrategy: .item(widthDimension: .fractionalWidth(1.0),
                                 heightDimension: .absolute(32 + 40)),
            scrollBehavior: .none
        )
    }
}

//MARK: - Review Content
extension ReviewSectionConverter {
    private func createReviewContentSection() -> [SectionModelType] {
        return []
    }
}

//MARK: - Review Image Content
extension ReviewSectionConverter {
    private func createReviewImageContentSection() -> [SectionModelType] {
        return []
    }
}

//MARK: - Terms Agreement
extension ReviewSectionConverter {
    private func createReviewTermsAgreementSection() -> [SectionModelType] {
        return []
    }
}


//MARK: - Terms Item
extension ReviewSectionConverter {
    private func createReviewTermsItemSection() -> [SectionModelType] {
        return []
    }
}
