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
    
    public var groupSpacing: CGFloat
    public var sectionInset: NSDirectionalEdgeInsets
    
    public var scrollBehavior: UICollectionLayoutSectionOrthogonalScrollingBehavior
    
    public init(itemStrategy: SizeStrategy,
                groupStrategy: SizeStrategy,
                headerStrategy: SizeStrategy? = nil,
                footerStrategy: SizeStrategy? = nil,
                groupSpacing: CGFloat = 0,
                sectionInset: NSDirectionalEdgeInsets = .init(vertical: 0, horizontal: 0),
                scrollBehavior: UICollectionLayoutSectionOrthogonalScrollingBehavior) {
        self.itemStrategy = itemStrategy
        self.groupStrategy = groupStrategy
        self.headerStrategy = headerStrategy
        self.footerStrategy = footerStrategy
        self.groupSpacing = groupSpacing
        self.sectionInset = sectionInset
        self.scrollBehavior = scrollBehavior
    }
}
