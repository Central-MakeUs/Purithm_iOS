//
//  FilterOptionDetailSectionConverter.swift
//  Filter
//
//  Created by 이숭인 on 8/6/24.
//

import CoreUIKit

final class FilterOptionDetailSectionConverter {
    func createSections(options: [FilterOptionModel]) -> [SectionModelType] {
        [
            createFilterOptionSections(with: options)
        ]
        .flatMap { $0 }
    }
}

extension FilterOptionDetailSectionConverter {
    private func createFilterOptionSections(with options: [FilterOptionModel]) -> [SectionModelType] {
        let components = options.map { option in
            FilterOptionComponent(
                identifier: option.identifier,
                option: option
            )
        }
        
        let section = SectionModel(
            identifier: "filter_option_section",
            collectionLayout: createFilterOptionCollectionLayout(),
            itemModels: components
        )
        
        return [section]
    }
    
    private func createFilterOptionCollectionLayout() -> CompositionalLayoutModelType {
        CompositionalLayoutModel(
            itemStrategy: .item(widthDimension: .estimated(80),
                                heightDimension: .absolute(40)),
            groupStrategy: .item(widthDimension: .fractionalWidth(0.5),
                                 heightDimension: .fractionalHeight(3.0)),
            itemSpacing: 20,
            sectionInset: .with(vertical: 40, horizontal: 20),
            scrollBehavior: .none)
    }
}
