//
//  Collection+Extension.swift
//  AlamofirePractice
//
//  Created by 이숭인 on 6/15/24.
//

import Foundation

extension Collection {
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    public subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
