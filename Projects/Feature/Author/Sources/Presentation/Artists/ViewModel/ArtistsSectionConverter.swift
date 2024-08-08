//
//  ArtistsSectionConverter.swift
//  Author
//
//  Created by 이숭인 on 8/8/24.
//

import CoreUIKit
import CoreCommonKit

final class ArtistsSectionConverter {
    func createSections(with artists: [ArtistScrapModel], orderOption: ArtistOrderOptionModel?) -> [SectionModelType] {
        [
            createOrderSection(with: orderOption),
            createArtistsSection(with: artists)
        ]
        .flatMap { $0 }
    }
}


//MARK: Feed
extension ArtistsSectionConverter {
    private func createArtistsSection(with artists: [ArtistScrapModel]) -> [SectionModelType] {
        let components = artists.map { artist in
            ArtistScrapItemComponentComponent(
                identifier: artist.identifier,
                scrapModel: artist
            )
        }
        
        let section = SectionModel(
            identifier: "image_pager_section",
            collectionLayout: createArtistsCollectionLayout(),
            itemModels: components
        )
        
        return [section]
    }
    
    private func createArtistsCollectionLayout() -> CompositionalLayoutModelType {
        CompositionalLayoutModel(
            itemStrategy: .item(widthDimension: .fractionalWidth(1.0),
                                heightDimension: .estimated(500)),
            groupStrategy: .item(widthDimension: .fractionalWidth(1.0),
                                 heightDimension: .estimated(500)),
            groupSpacing: 50,
            sectionInset: .with(top: 10, leading: 0, bottom: 20, trailing: 0),
            scrollBehavior: .none
        )
    }
}

//MARK: Order
extension ArtistsSectionConverter {
    private func createOrderSection(with option: ArtistOrderOptionModel?) -> [SectionModelType] {
        guard let option = option else {
            return []
        }
        
        let optionComponent = ArtistOrderOptionComponent(
            identifier: option.identifier,
            artistCount: option.artistCount,
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
