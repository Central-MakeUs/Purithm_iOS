//
//  PostedReviewSectionConverter.swift
//  Review
//
//  Created by 이숭인 on 8/12/24.
//

import UIKit
import CoreUIKit

final class PostedReviewSectionConverter {
    func createSections(review: FeedReviewModel) -> [SectionModelType] {
        [
            createReviewSection(with: review),
            createRemoveButtonSection()
        ]
        .flatMap { $0 }
        
    }
}

//MARK: Review Component
extension PostedReviewSectionConverter {
    private func createReviewSection(with review: FeedReviewModel) -> [SectionModelType] {
        let component = FeedDetailImageContainerComponent(
            identifier: review.identifier,
            review: review
        )
        
        let section = SectionModel(
            identifier: "review_section",
            collectionLayout: createReviewSectionCollectionLayout(),
            itemModels: [component]
        )
        
        return [section]
    }
    
    private func createReviewSectionCollectionLayout() -> CompositionalLayoutModelType {
        CompositionalLayoutModel(
            itemStrategy: .item(widthDimension: .fractionalWidth(1.0)
                                , heightDimension: .estimated(500)),
            groupStrategy: .item(widthDimension: .fractionalWidth(1.0)
                                 , heightDimension: .estimated(500)),
            sectionInset: .with(vertical: 20, horizontal: 20),
            scrollBehavior: .none
        )
    }
}

//MARK: - Bottom Button
extension PostedReviewSectionConverter {
    private func createRemoveButtonSection() -> [SectionModelType] {
        let component = ReviewRemoveButtonComponent(identifier: "remove_button")
        
        let section = SectionModel(
            identifier: "remove_button_section",
            collectionLayout: createRemoveButtonCollectionLayout(),
            itemModels: [component]
        )
        
        return [section]
    }
    
    private func createRemoveButtonCollectionLayout() -> CompositionalLayoutModelType {
        CompositionalLayoutModel(
            itemStrategy: .item(widthDimension: .fractionalWidth(1.0),
                                heightDimension: .absolute(48)),
            groupStrategy: .item(widthDimension: .fractionalWidth(1.0),
                                 heightDimension: .absolute(48)),
            sectionInset: NSDirectionalEdgeInsets(vertical: 20, horizontal: 20),
            scrollBehavior: .none
        )
    }
}
