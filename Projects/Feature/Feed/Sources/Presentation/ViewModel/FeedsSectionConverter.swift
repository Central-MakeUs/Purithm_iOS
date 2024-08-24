//
//  FeedsSectionConverter.swift
//  Feed
//
//  Created by 이숭인 on 8/8/24.
//

import Foundation
import CoreUIKit

final class FeedsSectionConverter {
    func createSections(
        with reviews: [FeedReviewModel],
        filterInfo: [(name: String, thumbnail: String)],
        orderOption: FeedOrderOptionModel?
    ) -> [SectionModelType] {
        [
            createOrderSection(with: orderOption),
            createFeedsSection(with: reviews, filterInfo: filterInfo)
        ]
        .flatMap { $0 }
    }
}

//MARK: Feed
extension FeedsSectionConverter {
    private func createFeedsSection(
        with reviews: [FeedReviewModel],
        filterInfo: [(name: String, thumbnail: String)]
    ) -> [SectionModelType] {
        let components = zip(reviews, filterInfo).map { review, info in
            FeedDetailImageContainerComponent(
                identifier: review.identifier,
                review: review,
                filterInformation: info, 
                isEnableDelete: false
            )
        }
        
        let section = SectionModel(
            identifier: "image_pager_section",
            collectionLayout: createFeedsCollectionLayout(),
            itemModels: components
        )
        
        return [section]
    }
    
    private func createFeedsCollectionLayout() -> CompositionalLayoutModelType {
        CompositionalLayoutModel(
            itemStrategy: .item(widthDimension: .fractionalWidth(1.0),
                                heightDimension: .estimated(500)),
            groupStrategy: .item(widthDimension: .fractionalWidth(1.0),
                                 heightDimension: .estimated(500)),
            groupSpacing: 50,
            sectionInset: .with(top: 10, leading: 0, bottom: 20, trailing: 0),
            scrollBehavior: .none
        )
    }
}

//MARK: Order
extension FeedsSectionConverter {
    private func createOrderSection(with option: FeedOrderOptionModel?) -> [SectionModelType] {
        guard let option = option else {
            return []
        }
        
        let optionComponent = FeedOrderOptionComponent(
            identifier: option.identifier,
            reviewCount: option.reviewCount,
            optionTitle: option.option.title
        )
        
        let section = SectionModel(
            identifier: "order_option_section",
            collectionLayout: createOrderOptionCollectionLayout(),
            itemModels: [optionComponent]
        )
        
        return [section]
    }
    
    private func createOrderOptionCollectionLayout() -> CompositionalLayoutModelType {
        CompositionalLayoutModel(
            itemStrategy: .item(widthDimension: .fractionalWidth(1.0),
                               heightDimension: .estimated(60)),
            groupStrategy: .group(widthDimension: .fractionalWidth(1.0),
                                 heightDimension: .estimated(60)),
           scrollBehavior: .none
        )
    }
}
