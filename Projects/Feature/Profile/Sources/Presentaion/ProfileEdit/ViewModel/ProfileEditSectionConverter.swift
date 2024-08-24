//
//  ProfileEditSectionConverter.swift
//  Profile
//
//  Created by 이숭인 on 8/22/24.
//

import Foundation
import CoreUIKit

final class ProfileEditSectionConverter {
    func createSections(
        name: String,
        thumbnail: String,
        isUploadState: Bool
    ) -> [SectionModelType] {
        [
            createProfileEditSection(
                with: thumbnail,
                isUploadState: isUploadState
            ),
            createProfileTextFieldSection(with: name)
        ]
        .flatMap { $0 }
    }
}

//MARK: - Profile
extension ProfileEditSectionConverter {
    private func createProfileEditSection(
        with thumbnail: String,
        isUploadState: Bool
    ) -> [SectionModelType] {
        let component = ProfileEditImageComponent(
            identifier: "profile_edit_component",
            thumbnailURLString: thumbnail, 
            isUploadState: isUploadState
        )
        
        let section = SectionModel(
            identifier: "profile_edit_section",
            collectionLayout: createProfileEditCollectionLayout(),
            itemModels: [component]
        )
        
        return [section]
    }
    
    private func createProfileEditCollectionLayout() -> CompositionalLayoutModelType {
        CompositionalLayoutModel(
            itemStrategy: .item(widthDimension: .fractionalWidth(1.0),
                                heightDimension: .estimated(180)),
            groupStrategy: .item(widthDimension: .fractionalWidth(1.0),
                                 heightDimension: .estimated(180)),
            scrollBehavior: .none)
    }
}

//MARK: - TextField
extension ProfileEditSectionConverter {
    private func createProfileTextFieldSection(with name: String) -> [SectionModelType] {
        let component = ProfileEditTextFieldComponent(
            identifier: "edit_text_field", 
            name: name
        )
        
        let section = SectionModel(
            identifier: "edit_name_section",
            collectionLayout: createProfileTextFieldCollectionLayout(),
            itemModels: [component]
        )
        
        return [section]
    }
    
    private func createProfileTextFieldCollectionLayout() -> CompositionalLayoutModelType {
        CompositionalLayoutModel(
            itemStrategy: .item(widthDimension: .fractionalWidth(1.0),
                                heightDimension: .estimated(120)),
            groupStrategy: .item(widthDimension: .fractionalWidth(1.0),
                                 heightDimension: .estimated(120)),
            sectionInset: .with(horizontal: 20),
            scrollBehavior: .none)
    }
}
