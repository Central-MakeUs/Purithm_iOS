//
//  FilterDetailSectionConverter.swift
//  Filter
//
//  Created by 이숭인 on 7/31/24.
//

import Combine
import CoreUIKit

final class FilterDetailSectionConverter {
    func createSections(with detailModel: FilterDetailModel) -> [SectionModelType] {
        [
            createImageSection(with: detailModel)
        ].flatMap { $0 }
    }
}

extension FilterDetailSectionConverter {
    private func createImageSection(with detailModel: FilterDetailModel) -> [SectionModelType] {
        let detailComponents = detailModel.detailImages.map { detailImage in
            FilterDetailComponent(
                identifier: detailImage.identifier,
                imageURLString: detailImage.imageURLString,
                originalImageURLString: detailImage.originalImageURLString,
                showOriginal: detailModel.isShowOriginal
            )
        }
        
        let section = SectionModel(
            identifier: "filter_detail_image_section",
            collectionLayout: createImageCollectionLayout(),
            itemModels: detailComponents
        )
        
        return [section]
    }
    
    private func createImageCollectionLayout() -> CompositionalLayoutModelType {
        CompositionalLayoutModel(
            itemStrategy: .item(widthDimension: .fractionalWidth(1.0),
                                heightDimension: .fractionalHeight(1.0)),
            groupStrategy: .group(widthDimension: .fractionalWidth(1.0),
                                  heightDimension: .fractionalHeight(1.0)),
            scrollBehavior: .groupPaging
        )
    }
}
