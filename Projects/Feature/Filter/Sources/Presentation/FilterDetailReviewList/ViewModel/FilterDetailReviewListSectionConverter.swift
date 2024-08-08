//
//  FilterDetailReviewListSectionConverter.swift
//  Filter
//
//  Created by 이숭인 on 8/5/24.
//

import Foundation
import CoreUIKit

final class FilterDetailReviewListSectionConverter {
    func createSections(with detailReviews: [FilterDetailReviewModel]) -> [SectionModelType] {
        [
            createImagePagerSection(with: detailReviews)
        ]
        .flatMap { $0 }
    }
}

//MARK: - ImamgePager
extension FilterDetailReviewListSectionConverter {
    private func createImagePagerSection(with reviews: [FilterDetailReviewModel]) -> [SectionModelType] {
        
        let components = reviews.map { review in
            FilterDetailImageContainerComponent(
                identifier: review.identifier,
                review: review
            )
        }
        
        let section = SectionModel(
            identifier: "image_pager_section",
            collectionLayout: createImagePagerCollectionLayout(),
            itemModels: components
        )
        
        return [section]
    }
    
    private func createImagePagerCollectionLayout() -> CompositionalLayoutModelType {
        CompositionalLayoutModel(
            itemStrategy: .item(widthDimension: .fractionalWidth(1.0),
                                heightDimension: .estimated(500)),
            groupStrategy: .item(widthDimension: .fractionalWidth(1.0),
                                 heightDimension: .estimated(500)),
            groupSpacing: 50,
            sectionInset: .with(bottom: 100),
            scrollBehavior: .none
        )
    }
}
