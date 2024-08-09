//
//  ReviewSectionConverter.swift
//  Review
//
//  Created by 이숭인 on 8/9/24.
//

import UIKit
import CoreUIKit
import CoreCommonKit

final class ReviewSectionConverter {
    func createSections(headerModel: ReviewHeaderComponentModel,
                        willUploadImageModels: [ReviewUploadImageContainerComponentModel]) -> [SectionModelType] {
        [
            createHeaderSection(with: headerModel),
            createSliderSection(),
            createReviewContentSection(),
            createReviewImageContentSection(with: willUploadImageModels),
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
                                heightDimension: .absolute(54 + 40)),
            groupStrategy: .item(widthDimension: .fractionalWidth(1.0),
                                 heightDimension: .absolute(54 + 40)),
            scrollBehavior: .none
        )
    }
}

//MARK: - Review Content
extension ReviewSectionConverter {
    private func createReviewContentSection() -> [SectionModelType] {
        let component = ReviewTextViewComponent(identifier: "textview_component")
        
        let section = SectionModel(
            identifier: "review_textview_section",
            collectionLayout: createReviewContentCollectionLayout(),
            itemModels: [component]
        )
        return [section]
    }
    
    private func createReviewContentCollectionLayout() -> CompositionalLayoutModelType {
        CompositionalLayoutModel(
            itemStrategy: .item(widthDimension: .fractionalWidth(1.0),
                                heightDimension: .absolute(240 + 60)),
            groupStrategy: .item(widthDimension: .fractionalWidth(1.0),
                                 heightDimension: .absolute(240 + 60)),
            scrollBehavior: .none
        )
    }
}

//MARK: - Review Image Content
extension ReviewSectionConverter {
    private func createReviewImageContentSection(with imageContainerModels: [ReviewUploadImageContainerComponentModel]) -> [SectionModelType] {
        let components = imageContainerModels.map { model in
            return ReviewUploadImageContainerComponent(
                identifier: model.identifier,
                model: model
            )
        }
        
        let section = SectionModel(
            identifier: "image_upload_container_section",
            collectionLayout: createReviewImageContentCollectionLayout(),
            itemModels: components
        )
        
        return [section]
    }
    
    private func createReviewImageContentCollectionLayout() -> CompositionalLayoutModelType {
        CompositionalLayoutModel(
            itemStrategy: .item(widthDimension: .fractionalWidth(1/3),
                                heightDimension: .estimated(100)),
            groupStrategy: .item(widthDimension: .fractionalWidth(1.0),
                                 heightDimension: .estimated(100)),
            isHorizontalGroup: true,
            itemSpacing: 20,
            sectionInset: NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20),
            scrollBehavior: .none
        )
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
