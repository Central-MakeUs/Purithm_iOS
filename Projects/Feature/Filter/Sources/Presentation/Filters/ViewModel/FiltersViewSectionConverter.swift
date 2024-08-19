//
//  FiltersViewSectionConverter.swift
//  Filter
//
//  Created by 이숭인 on 7/29/24.
//

import Combine
import CoreUIKit

final class FiltersChipSectionConverter {
    func createSections(chips: [FilterChipModel]) -> [SectionModelType] {
        [
            createChipSection(with: chips)
        ]
        .flatMap { $0 }
    }
}

extension FiltersChipSectionConverter {
    private func createChipSection(with chips: [FilterChipModel]) -> [SectionModelType] {
        let chipComponent = chips.map { chip in
            FilterChipComponent(identifier: chip.identifier, item: chip)
        }
        
        let section = SectionModel(
            identifier: "chip_section",
            collectionLayout: createChipCollectionLayout(),
            itemModels: chipComponent
        )
        
        return [section]
    }
    
    private func createChipCollectionLayout() -> CompositionalLayoutModelType {
         CompositionalLayoutModel(
            itemStrategy: .item(widthDimension: .estimated(100),
                                heightDimension: .estimated(36)),
            groupStrategy: .group(widthDimension: .estimated(100),
                                  heightDimension: .estimated(36)),
            groupSpacing: 8,
            sectionInset: .with(top: 0, leading: 10, bottom: 0, trailing: 10),
            scrollBehavior: .continuous
         )
    }
}

final class FiltersViewSectionConverter {
    func createSections(
        orderOption: FilterOrderOptionModel?,
        filters: [FilterItemModel],
        isLast: Bool
    ) -> [SectionModelType] {
        [
            filters.isEmpty ? [] : createOrderOptionSection(with: orderOption),
            createFilterItemSection(with: filters),
            filters.isEmpty ? [] : createLoadMoreSection(with: isLast)
        ].flatMap { $0 }
    }
}

//MARK: - Order Option Section
extension FiltersViewSectionConverter {
    private func createOrderOptionSection(with option: FilterOrderOptionModel?) -> [SectionModelType] {
        guard let option = option else {
            return []
        }
        
        let optionComponent = FilterOrderOptionComponent(
            identifier: option.identifier,
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
extension FiltersViewSectionConverter {
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
extension FiltersViewSectionConverter {
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
