//
//  FilterReviewsSectionConverter.swift
//  Filter
//
//  Created by 이숭인 on 8/5/24.
//

import Foundation
import CoreUIKit
import Combine

final class FilterReviewsSectionConverter {
    func createSections(satisfaction: FilterSatisfactionModel, reviews: [FilterReviewItemModel]) -> [SectionModelType] {
        [
            createSatisfactionSections(with: satisfaction),
            createReviewsSections(with: reviews)
        ]
        .flatMap { $0 }
    }
}

//MARK: Satisfaction
extension FilterReviewsSectionConverter {
    private func createSatisfactionSections(with satisfaction: FilterSatisfactionModel) -> [SectionModelType] {
        let component = FilterReviewSatiscationComponent(
            identifier: satisfaction.identifier,
            satisfactionLevel: satisfaction.satisfactionLevel
        )
        
        let section = SectionModel(
            identifier: "satisfaction_section",
            collectionLayout: createSatisfactionSectionCollectionLayout(),
            itemModels: [component]
        )
        
        return [section]
    }
    
    private func createSatisfactionSectionCollectionLayout() -> CompositionalLayoutModelType {
        CompositionalLayoutModel(
            itemStrategy: .item(widthDimension: .fractionalWidth(1.0),
                                heightDimension: .absolute(200)),
            groupStrategy: .item(widthDimension: .fractionalWidth(1.0),
                                 heightDimension: .absolute(200)),
            scrollBehavior: .none
        )
    }
}

//MARK: - Reviews
extension FilterReviewsSectionConverter {
    private func createReviewsSections(with reviews: [FilterReviewItemModel]) -> [SectionModelType] {
        let reviewComponents = reviews.map { review in
            FilterReviewItemComponent(
                identifier: review.identifier,
                reviewItem: review
            )
        }
        
        let section = SectionModel(
            identifier: "review_section",
            collectionLayout: createReviewsSectionCollectionLayout(),
            itemModels: reviewComponents
        )
        
        return [section]
    }
    
    private func createReviewsSectionCollectionLayout() -> CompositionalLayoutModelType {
        CompositionalLayoutModel(
            itemStrategy: .item(widthDimension: .fractionalWidth(0.5),
                                heightDimension: .estimated(200)),
            groupStrategy: .item(widthDimension: .fractionalWidth(1.0),
                                 heightDimension: .estimated(200)),
            isHorizontalGroup: true,
            itemSpacing: 12,
            groupSpacing: 30,
            sectionInset: .with(top: 30, leading: 20, bottom: 100, trailing: 20),
            scrollBehavior: .none
        )
    }
}
