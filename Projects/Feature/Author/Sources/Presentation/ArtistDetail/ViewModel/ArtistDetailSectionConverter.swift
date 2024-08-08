//
//  ArtistDetailSectionConverter.swift
//  Author
//
//  Created by 이숭인 on 8/9/24.
//

import Foundation
import CoreUIKit

final class ArtistDetailSectionConverter {
    func createSections(profileModel: PurithmVerticalProfileModel, option: ArtistDetailOrderOptionModel?) -> [SectionModelType] {
        [
            createProfileSection(with: profileModel),
            createOrderSection(with: option)
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
