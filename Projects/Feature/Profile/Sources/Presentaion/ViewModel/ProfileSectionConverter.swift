//
//  ProfileSectionConverter.swift
//  Profile
//
//  Created by 이숭인 on 8/19/24.
//

import Foundation
import CoreUIKit

final class ProfileSectionConverter {
    func createSections(
        menus: [ProfileSettingMenu]
    ) -> [SectionModelType] {
        [
            createMenuSection(with: menus)
        ]
        .flatMap { $0 }
    }
}

extension ProfileSectionConverter {
    private func createMenuSection(with menus: [ProfileSettingMenu]) -> [SectionModelType] {
        let components = menus.map {
            ProfileSettingMenuComponent(
                identifier: $0.identifier,
                menu: $0
            )
        }
        let header = ProfileSettingMenuHeaderComponent(
            identifier: "menu_header",
            title: "계정 관리"
        )
        
        let section = SectionModel(
            identifier: "profile_setting_section",
            collectionLayout: createMenuCollectionLayout(),
            header: header,
            itemModels: components
        )
        
        return [section]
    }
    
    private func createMenuCollectionLayout() -> CompositionalLayoutModelType {
        CompositionalLayoutModel(
            itemStrategy: .item(widthDimension: .fractionalWidth(1.0),
                                heightDimension: .absolute(56)),
            groupStrategy: .item(widthDimension: .fractionalWidth(1.0),
                                 heightDimension: .absolute(56)),
            headerStrategy: .header(widthDimension: .fractionalWidth(1.0),
                                    heightDimension: .absolute(58)),
            sectionInset: .with(vertical: 20, horizontal: 20),
            scrollBehavior: .none
        )
    }
}
