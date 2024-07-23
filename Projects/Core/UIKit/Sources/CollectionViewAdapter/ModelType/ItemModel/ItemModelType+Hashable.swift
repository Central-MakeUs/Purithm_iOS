//
//  ItemModelType+Hashable.swift
//  AlamofirePractice
//
//  Created by 이숭인 on 6/13/24.
//

import Foundation

public struct ListItem: Hashable {
    let itemModel: ItemModelType
    var differenceIdentifier: String { itemModel.identifier }
    
    public static func == (lhs: ListItem, rhs: ListItem) -> Bool {
        lhs.itemModel.hashValue == rhs.itemModel.hashValue
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(itemModel.hashValue)
    }
}
