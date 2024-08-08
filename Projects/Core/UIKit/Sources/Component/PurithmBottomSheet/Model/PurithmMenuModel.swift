//
//  PurithmMenuModel.swift
//  CoreUIKit
//
//  Created by 이숭인 on 8/7/24.
//

import Foundation

public struct PurithmMenuModel {
    let identifier: String
    let title: String
    let isSelected: Bool
    
    public init(identifier: String, title: String, isSelected: Bool) {
        self.identifier = identifier
        self.title = title
        self.isSelected = isSelected
    }
}
