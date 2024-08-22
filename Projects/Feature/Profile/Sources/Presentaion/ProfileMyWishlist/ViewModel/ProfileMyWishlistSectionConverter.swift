//
//  ProfileMyWishlistSectionConverter.swift
//  Profile
//
//  Created by 이숭인 on 8/22/24.
//

import Combine
import CoreUIKit

final class ProfileMyWishlistSectionConverter {
    func createSections(
        filters: [FilterItemModel]
    ) -> [SectionModelType] {
        [
            createFilterItemSection(with: filters)
        ]
        .flatMap { $0 }
    }
}

//MARK: - Filter Item Section
extension ProfileMyWishlistSectionConverter {
    private func createFilterItemSection(with filters: [FilterItemModel]) -> [SectionModelType] {
        let header = ProfileWishlistHeaderComponent(
            identifier: "feed_header",
            count: filters.count
        )
        
        let filterComponents = filters.map { filter in
            FilterItemComponent(
                identifier: filter.identifier,
                item: filter)
        }
        
        let section = SectionModel(
            identifier: "filter_item_section",
            collectionLayout: createFilterItemCollectionLayout(),
            header: header,
            itemModels: filterComponents)
        
        return [section]
    }
    
    private func createFilterItemCollectionLayout() -> CompositionalLayoutModelType {
        CompositionalLayoutModel(
            itemStrategy: .item(widthDimension: .fractionalWidth(0.5),
                                heightDimension: .estimated(200)),
            groupStrategy: .group(widthDimension: .fractionalWidth(1.0),
                                  heightDimension: .estimated(200)),
            headerStrategy: .header(widthDimension: .fractionalWidth(1.0),
                                    heightDimension: .absolute(60)),
            isHorizontalGroup: true,
            itemSpacing: 12,
            groupSpacing: 30,
            sectionInset: .with(top: 10, leading: 20, bottom: 20, trailing: 20),
            scrollBehavior: .none
        )
    }
}
