//
//  CompositionalLayoutModelType.swift
//  AlamofirePractice
//
//  Created by 이숭인 on 6/12/24.
//

import UIKit

/// CollectionLayout 을 만들기 위한 ModelType 으로 정의
public protocol CompositionalLayoutModelType {
    var itemStrategy: SizeStrategy { get set }
    var groupStrategy: SizeStrategy { get set }
    
    var headerStrategy: SizeStrategy? { get }
    var footerStrategy: SizeStrategy? { get }
    
    var isHorizontalGroup: Bool { get }
    var itemSpacing: CGFloat { get }
    var groupSpacing: CGFloat { get }
    var sectionInset: NSDirectionalEdgeInsets { get set }
    
    var scrollBehavior: UICollectionLayoutSectionOrthogonalScrollingBehavior { get }
}

public enum SizeStrategy {
    case item(widthDimension: NSCollectionLayoutDimension, heightDimension: NSCollectionLayoutDimension)
    case group(widthDimension: NSCollectionLayoutDimension, heightDimension: NSCollectionLayoutDimension)
    case header(widthDimension: NSCollectionLayoutDimension, heightDimension: NSCollectionLayoutDimension)
    case footer(widthDimension: NSCollectionLayoutDimension, heightDimension: NSCollectionLayoutDimension)
    
    var value: (widthDimension: NSCollectionLayoutDimension, heightDimension: NSCollectionLayoutDimension) {
        switch self {
        case let .item(width, height),
            let .group(width, height),
            let .header(width, height),
            let .footer(width, height):
            return (width, height)
        }
    }
}
