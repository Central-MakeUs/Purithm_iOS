//
//  ProfileMyReviewsSectionConverter.swift
//  Profile
//
//  Created by 이숭인 on 8/22/24.
//

import Foundation
import CoreUIKit

final class ProfileMyReviewsSectionConverter {
    func createSections(
        with reviews: [FeedReviewModel],
        filterInfo: [(name: String, thumbnail: String)]
    ) -> [SectionModelType] {
        [
            createFeedSection(
                with: reviews,
                filterInfo: filterInfo
            )
        ]
        .flatMap { $0 }
    }
} 

//MARK: - Feed
extension ProfileMyReviewsSectionConverter {
    private func createFeedSection(
        with reviews: [FeedReviewModel],
        filterInfo: [(name: String, thumbnail: String)]
    ) -> [SectionModelType] {
        let header = ProfileFeedHeaderComponent(
            identifier: "feed_header",
            count: reviews.count
        )
        
        let components = zip(reviews, filterInfo).map { review, info in
            FeedDetailImageContainerComponent(
                identifier: review.identifier,
                review: review,
                filterInformation: info,
                isEnableDelete: true
            )
        }
        
        let section = SectionModel(
            identifier: "image_pager_section",
            collectionLayout: createFeedsCollectionLayout(),
            header: header,
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
            headerStrategy: .header(widthDimension: .fractionalWidth(1.0),
                                    heightDimension: .absolute(60)),
            groupSpacing: 50,
            sectionInset: .with(top: 10, leading: 20, bottom: 20, trailing: 20),
            scrollBehavior: .none
        )
    }
}
