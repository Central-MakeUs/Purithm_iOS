//
//  CompositionalLayoutModel.swift
//
//  Created by 이숭인 on 7/19/24.
//

import UIKit

public struct CompositionalLayoutModel: CompositionalLayoutModelType {
    public var itemStrategy: SizeStrategy
    public var groupStrategy: SizeStrategy
    
    public var headerStrategy: SizeStrategy?
    public var footerStrategy: SizeStrategy?
    
    public var isHorizontalGroup: Bool
    
    public var itemSpacing: CGFloat
    public var groupSpacing: CGFloat
    public var sectionInset: NSDirectionalEdgeInsets
    
    public var scrollBehavior: UICollectionLayoutSectionOrthogonalScrollingBehavior
    
    public init(itemStrategy: SizeStrategy,
                groupStrategy: SizeStrategy,
                headerStrategy: SizeStrategy? = nil,
                footerStrategy: SizeStrategy? = nil,
                isHorizontalGroup: Bool = false,
                itemSpacing: CGFloat = 0,
                groupSpacing: CGFloat = 0,
                sectionInset: NSDirectionalEdgeInsets = .init(vertical: 0, horizontal: 0),
                scrollBehavior: UICollectionLayoutSectionOrthogonalScrollingBehavior) {
        self.itemStrategy = itemStrategy
        self.groupStrategy = groupStrategy
        self.headerStrategy = headerStrategy
        self.footerStrategy = footerStrategy
        self.isHorizontalGroup = isHorizontalGroup
        self.itemSpacing = itemSpacing
        self.groupSpacing = groupSpacing
        self.sectionInset = sectionInset
        self.scrollBehavior = scrollBehavior
    }
}
