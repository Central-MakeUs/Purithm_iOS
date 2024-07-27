//
//  SectionModel.swift
//  AlamofirePractice
//
//  Created by 이숭인 on 6/13/24.
//

import UIKit

public struct SectionModel: SectionModelType {
    public var collectionLayout: CompositionalLayoutModelType
    
    public let identifier: String
    public let header: ItemModelType?
    public let footer: ItemModelType?

    public let itemModels: [ItemModelType]

    public init(identifier: String,
                collectionLayout: CompositionalLayoutModelType,
                header: ItemModelType? = nil,
                footer: ItemModelType? = nil,
                itemModels: [ItemModelType]) {
        self.identifier = identifier
        self.collectionLayout = collectionLayout
        self.header = header
        self.footer = footer
        self.itemModels = itemModels
    }

    public func hash(into hasher: inout Hasher) { }
}
