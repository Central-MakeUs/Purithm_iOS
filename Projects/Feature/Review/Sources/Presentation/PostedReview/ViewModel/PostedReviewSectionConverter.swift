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
            createReviewSection(with: review)
        ]
        .flatMap { $0 }
        
    }
}

//MARK: Review Component
extension PostedReviewSectionConverter {
    private func createReviewSection(with review: FeedReviewModel) -> [SectionModelType] {
        let component = FeedDetailImageContainerComponent(
            identifier: review.identifier,
            review: review, 
            isEnableDelete: true
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
            sectionInset: .with(vertical: 40, horizontal: 20),
            scrollBehavior: .none
        )
    }
}
