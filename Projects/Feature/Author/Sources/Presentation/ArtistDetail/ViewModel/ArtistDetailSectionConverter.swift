//
//  ArtistDetailSectionConverter.swift
//  Author
//
//  Created by 이숭인 on 8/9/24.
//

import Foundation
import CoreUIKit

final class ArtistDetailSectionConverter {
    func createSections(profileModel: PurithmVerticalProfileModel) -> [SectionModelType] {
        [
            createProfileSection(with: profileModel)
        ]
        .flatMap { $0 }
    }
}

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
