//
//  ProfileSettingSectionConverter.swift
//  Profile
//
//  Created by 이숭인 on 8/19/24.
//

import Foundation
import CoreUIKit

final class ProfileSettingSectionConverter {
    func createSections(
        menus: [ProfileSettingMenu]
    ) -> [SectionModelType] {
        [
            createAccountManageSection(with: menus),
            createDividerSection(),
            createOtherItemsSection(with: menus),
        ]
            .flatMap { $0 }
    }
    
    private func createMenuCollectionLayout() -> CompositionalLayoutModelType {
        CompositionalLayoutModel(
            itemStrategy: .item(widthDimension: .fractionalWidth(1.0),
                                heightDimension: .absolute(56)),
            groupStrategy: .item(widthDimension: .fractionalWidth(1.0),
                                 heightDimension: .absolute(56)),
            headerStrategy: .header(widthDimension: .fractionalWidth(1.0),
                                    heightDimension: .absolute(58)),
            sectionInset: .with(horizontal: 20),
            scrollBehavior: .none
        )
    }
}

//MARK: - Account Manage Section
extension ProfileSettingSectionConverter {
    private func createAccountManageSection(with menus: [ProfileSettingMenu]) -> [SectionModelType] {
        let header = ProfileSettingMenuHeaderComponent(
            identifier: "menu_top_header",
            title: "계정 관리"
        )
        let components = menus.filter { $0 == .accountInfo || $0 == .editProfile }.map {
            ProfileSettingMenuComponent(
                identifier: $0.identifier,
                menu: $0
            )
        }
        let section = SectionModel(
            identifier: "profile_setting_top_section",
            collectionLayout: createMenuCollectionLayout(),
            header: header,
            itemModels: components
        )
        
        return [section]
    }
}

//MARK: - Other Items Section
extension ProfileSettingSectionConverter {
    private func createOtherItemsSection(with menus: [ProfileSettingMenu]) -> [SectionModelType] {
        let header = ProfileSettingMenuHeaderComponent(
            identifier: "menu_bottom_header",
            title: "기타"
        )
        
        let components = menus.filter { $0 != .accountInfo && $0 != .editProfile }.map {
            ProfileSettingMenuComponent(
                identifier: $0.identifier,
                menu: $0
            )
        }
        
        let bottomSection = SectionModel(
            identifier: "profile_setting_bottom_section",
            collectionLayout: createMenuCollectionLayout(),
            header: header,
            itemModels: components
        )
        return [bottomSection]
    }
}

//MARK: - Divier Section
extension ProfileSettingSectionConverter {
    private func createDividerSection() -> [SectionModelType] {
        let dividerComponent = DividerComponent(identifier: "divider")
        let dividerSection = SectionModel(
            identifier: "divider_section",
            collectionLayout: createDividerCollectionLayout(),
            itemModels: [dividerComponent]
        )
        
        return [dividerSection]
    }
    
    private func createDividerCollectionLayout() -> CompositionalLayoutModelType {
        CompositionalLayoutModel(
            itemStrategy: .item(widthDimension: .fractionalWidth(1.0),
                                heightDimension: .absolute(41)),
            groupStrategy: .item(widthDimension: .fractionalWidth(1.0),
                                 heightDimension: .absolute(41)),
            sectionInset: .with(horizontal: 20),
            scrollBehavior: .none
        )
    }
}
