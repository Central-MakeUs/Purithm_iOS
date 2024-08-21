//
//  ProfileAccountInfomationSectionConverter.swift
//  Profile
//
//  Created by 이숭인 on 8/22/24.
//

import Foundation
import CoreUIKit

final class ProfileAccountInfomationSectionConverter {
    func createSections(with accountModel: ProfileAccountInfomationModel) -> [SectionModelType] {
        [
            createAccountInfomationSection(with: accountModel)
        ]
        .flatMap { $0 }
    }
}

extension ProfileAccountInfomationSectionConverter {
    private func createAccountInfomationSection(with accountModel:ProfileAccountInfomationModel) -> [SectionModelType] {
        let methodComponent = ProfileAccountItemComponent(
            identifier: "method_component",
            infomationType: .signUpMethod,
            infomation: accountModel.signUpMethod.rawValue
        )
        
        let emailComponent = ProfileAccountItemComponent(
            identifier: "email_component",
            infomationType: .email,
            infomation: accountModel.email
        )
        
        let dateOfJoinComponent = ProfileAccountItemComponent(
            identifier: "date_of_join_component",
            infomationType: .dateOfJoin,
            infomation: accountModel.dateOfJoining
        )
        
        let section = SectionModel(
            identifier: "account_info_section",
            collectionLayout: createAccountInfoCollectionLayout(),
            itemModels: [methodComponent, emailComponent, dateOfJoinComponent]
        )
        
        return [section]
    }
    
    private func createAccountInfoCollectionLayout() -> CompositionalLayoutModelType {
        CompositionalLayoutModel(
            itemStrategy: .item(widthDimension: .fractionalWidth(1.0),
                                heightDimension: .absolute(42)),
            groupStrategy: .item(widthDimension: .fractionalWidth(1.0),
                                 heightDimension: .absolute(42)),
            sectionInset: .with(vertical: 20, horizontal: 20),
            scrollBehavior: .none
        )
    }
}

    
