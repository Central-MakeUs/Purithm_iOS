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
        with profileInfomation: ProfileUserInfomationModel
    ) -> [SectionModelType] {
        [
            createProfileSection(with: profileInfomation),
            createStampSection(with: profileInfomation)
        ]
        .flatMap { $0 }
    }
}

//MARK: - Profile
extension ProfileSectionConverter {
    private func createProfileSection(with profileModel: ProfileUserInfomationModel) -> [SectionModelType] {
        let verticalProfileModel = PurithmVerticalProfileModel(
            identifier: profileModel.userID,
            type: .user,
            name: profileModel.userName,
            profileURLString: profileModel.profileURLString,
            introduction: ""
        )
        
        let component = ProfileUserProfileComponent(
            identifier: profileModel.userID,
            profileModel: verticalProfileModel
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

//MARK: - Stamp
extension ProfileSectionConverter {
    private func createStampSection(with stampModel: ProfileUserInfomationModel) -> [SectionModelType] {
        let component = ProfileStampContainerComponent(
            identifier: "stamp_container",
            stampCount: stampModel.stampCount
        )
        
        let section = SectionModel(
            identifier: "stamp_section",
            collectionLayout: createStampCollectionLayout(),
            itemModels: [component]
        )
        
        return [section]
    }
    
    private func createStampCollectionLayout() -> CompositionalLayoutModelType {
        CompositionalLayoutModel(
            itemStrategy: .item(widthDimension: .fractionalWidth(1.0),
                                heightDimension: .estimated(70)),
            groupStrategy: .item(widthDimension: .fractionalWidth(1.0),
                                 heightDimension: .estimated(70)),
            sectionInset: .with(vertical: 20, horizontal: 20),
            scrollBehavior: .none
        )
    }
}
