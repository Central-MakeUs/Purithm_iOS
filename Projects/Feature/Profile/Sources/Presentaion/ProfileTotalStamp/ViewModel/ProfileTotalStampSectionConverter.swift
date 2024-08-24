//
//  ProfileTotalStampSectionConverter.swift
//  Profile
//
//  Created by 이숭인 on 8/23/24.
//

import Foundation
import CoreUIKit

final class ProfileTotalStampSectionConverter {
    func createSections(
        cards: [String: [ProfileFilterCardModel]]
    ) -> [SectionModelType] {
        [
            createStampDescriptionSection(),
            createCountHeader(cards: cards),
            craateFilterCardSection(cards: cards)
        ]
        .flatMap { $0 }
    }
}

extension ProfileTotalStampSectionConverter {
    private func createStampDescriptionSection() -> [SectionModelType] {
        let component = ProfileStampDescriptionComponent(
            identifier: "stamp_description"
        )
        
        let section = SectionModel(
            identifier: "stamp_description_section",
            collectionLayout: createStampDescriptionCollectionLayout(),
            itemModels: [component]
        )
        
        return [section]
    }
    
    private func createStampDescriptionCollectionLayout() -> CompositionalLayoutModelType {
        CompositionalLayoutModel(
            itemStrategy: .item(widthDimension: .fractionalWidth(1.0), 
                                heightDimension: .estimated(124)),
            groupStrategy: .item(widthDimension: .fractionalWidth(1.0),
                                 heightDimension: .estimated(124)),
            sectionInset: .with(top: 20, leading: 20, bottom: 0, trailing: 20),
            scrollBehavior: .none)
    }
}

//MARK: - Count Header
extension ProfileTotalStampSectionConverter {
    private func createCountHeader(cards: [String: [ProfileFilterCardModel]]) -> [SectionModelType] {
        let cardCount = cards.values.flatMap { $0 }.count
        let header = ProfileFilterCardCountHeaderComponent(
            identifier: "header_component",
            count: cardCount, 
            showDescription: true
        )
        
        let section = SectionModel(
            identifier: "card_count_header",
            collectionLayout: createCountHeaderCollectionLayout(),
            itemModels: [header]
        )
        
        return [section]
    }
    
    private func createCountHeaderCollectionLayout() -> CompositionalLayoutModelType {
        CompositionalLayoutModel(
            itemStrategy: .item(widthDimension: .fractionalWidth(1.0),
                                heightDimension: .estimated(20)),
            groupStrategy: .item(widthDimension: .fractionalWidth(1.0),
                                 heightDimension: .estimated(20)),
            sectionInset: .with(vertical: 10, horizontal: 20),
            scrollBehavior: .none)
    }
}

//MARK: - Card
extension ProfileTotalStampSectionConverter {
    private func craateFilterCardSection(
        cards: [String: [ProfileFilterCardModel]]
    ) -> [SectionModelType] {
        var sections: [SectionModelType] = []
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        
        cards.sorted { $0.key > $1.key }.forEach { (key, cardModels) in
            let header = ProfileFilterCardHeaderComponent(
                identifier: key,
                date: key
            )
            
            let cardComponents = cardModels.map { card in
                ProfileFilterCardComponent(
                    identifier: card.filterId,
                    model: card,
                    canAccessOnlyReview: true
                )
            }
            
            let section = SectionModel(
                identifier: "card_section_\(key)",
                collectionLayout: createFilterCardCollectionLayout(),
                header: header,
                itemModels: cardComponents
            )
            
            sections.append(section)
        }
        
        return sections
    }
    
    private func createFilterCardCollectionLayout() -> CompositionalLayoutModelType {
        CompositionalLayoutModel(
            itemStrategy: .item(widthDimension: .fractionalWidth(1.0),
                                heightDimension: .estimated(178)),
            groupStrategy: .item(widthDimension: .fractionalWidth(1.0),
                                 heightDimension: .estimated(178)),
            headerStrategy: .header(widthDimension: .fractionalWidth(1.0),
                                    heightDimension: .absolute(22)),
            groupSpacing: 20,
            sectionInset: .with(vertical: 20, horizontal: 20),
            scrollBehavior: .none
        )
    }
}
