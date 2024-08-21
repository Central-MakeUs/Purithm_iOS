//
//  ProfileSectionConverter.swift
//  Profile
//
//  Created by 이숭인 on 8/21/24.
//

import Foundation
import CoreUIKit

final class ProfileSectionConverter {
    func createSections(
        with profileModel: PurithmVerticalProfileModel
    ) -> [SectionModelType] {
        [
            createProfileSection(with: profileModel)
        ]
        .flatMap { $0 }
    }
}

//MARK: - Profile
extension ProfileSectionConverter {
    private func createProfileSection(with profileModel: PurithmVerticalProfileModel) -> [SectionModelType] {
        let component = ProfileUserProfileComponent(
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
