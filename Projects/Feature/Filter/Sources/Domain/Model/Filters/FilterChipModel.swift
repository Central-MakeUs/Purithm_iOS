//
//  FilterChipModel.swift
//  Filter
//
//  Created by 이숭인 on 7/29/24.
//

import Foundation

struct FilterChipModel: Hashable {
    let identifier: String
    let title: String
    var isSelected: Bool
    let chipType: FilterChipType
}
