//
//  ArtistDetailSectionConverter.swift
//  Author
//
//  Created by 이숭인 on 8/9/24.
//

import Foundation
import CoreUIKit

final class ArtistDetailSectionConverter {
    func createSections(profileModel: PurithmVerticalProfileModel,
                        option: ArtistDetailOrderOptionModel?,
                        filters: [FilterItemModel],
                        isLast: Bool) -> [SectionModelType] {
        [
            createProfileSection(with: profileModel),
            createOrderSection(with: option),
            createFilterItemSection(with: filters),
            createLoadMoreSection(with: isLast)
        ]
        .flatMap { $0 }
    }
}

//MARK: - Profile
extension ArtistDetailSectionConverter {
    private func createProfileSection(with profileModel: PurithmVerticalProfileModel) -> [SectionModelType] {
        let component = ArtistProfileComponentComponent(
            identifier: profileModel.identifier,
            profileModel: profileModel
        )
        
        let section = SectionModel(
            identifier: "profile_section",
            collectionLayout: createProfileCollectionLayout(),
            itemModels: [component]
        )
        
        return [section]
    }
    
    private func createProfileCollectionLayout() -> CompositionalLayoutModelType {
        CompositionalLayoutModel(
            itemStrategy: .item(widthDimension: .fractionalWidth(1.0),
                                heightDimension: .absolute(240)),
            groupStrategy: .item(widthDimension: .fractionalWidth(1.0),
                                 heightDimension: .absolute(240)),
            scrollBehavior: .none
        )
    }
}

//MARK: - Order Option
extension ArtistDetailSectionConverter {
    private func createOrderSection(with option: ArtistDetailOrderOptionModel?) -> [SectionModelType] {
        guard let option = option else {
            return []
        }
        
        let optionComponent = ArtistDetailOrderOptionComponent(
            identifier: option.identifier,
            filterCount: option.filterCount,
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

//MARK: - Filter Item Section
extension ArtistDetailSectionConverter {
    private func createFilterItemSection(with filters: [FilterItemModel]) -> [SectionModelType] {
        let filterComponents = filters.map { filter in
            FilterItemComponent(
                identifier: filter.identifier,
                item: filter)
        }
        
        let section = SectionModel(
            identifier: "filter_item_section",
            collectionLayout: createFilterItemCollectionLayout(),
            itemModels: filterComponents)
        
        return [section]
    }
    
    private func createFilterItemCollectionLayout() -> CompositionalLayoutModelType {
        CompositionalLayoutModel(
            itemStrategy: .item(widthDimension: .fractionalWidth(0.5),
                                heightDimension: .estimated(200)),
            groupStrategy: .group(widthDimension: .fractionalWidth(1.0),
                                  heightDimension: .estimated(200)),
            isHorizontalGroup: true,
            itemSpacing: 12,
            groupSpacing: 30,
            sectionInset: .with(vertical: 0, horizontal: 20),
            scrollBehavior: .none
        )
    }
}

//MARK: Load More Trigger Section
extension ArtistDetailSectionConverter {
    private func createLoadMoreSection(with isLast: Bool) -> [SectionModelType] {
        let component = LoadMoreTriggerComponent(
            identifier: "load_more_trigger",
            isLast: isLast
        )
        
        let section = SectionModel(
            identifier: "load_more_section",
            collectionLayout: createLoadMoreCollectionLayout(),
            itemModels: [component]
        )
        
        return [section]
    }
    
    private func createLoadMoreCollectionLayout() -> CompositionalLayoutModelType {
        CompositionalLayoutModel(
            itemStrategy: .item(widthDimension: .fractionalWidth(1.0),
                                heightDimension: .absolute(60)),
            groupStrategy: .item(widthDimension: .fractionalWidth(1.0),
                                 heightDimension: .absolute(60)),
            scrollBehavior: .none
        )
    }
}
