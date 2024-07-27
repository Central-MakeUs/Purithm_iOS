//
//  SectionModelType+Hashable.swift
//  AlamofirePractice
//
//  Created by 이숭인 on 6/17/24.
//

import Foundation

public struct SectionItem: Hashable {
    let sectionModel: SectionModelType
    var differenceIdentifier: String { sectionModel.identifier }
    
    public static func == (lhs: SectionItem, rhs: SectionItem) -> Bool {
        lhs.sectionModel.hashValue == rhs.sectionModel.hashValue
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(sectionModel.hashValue)
    }
}
