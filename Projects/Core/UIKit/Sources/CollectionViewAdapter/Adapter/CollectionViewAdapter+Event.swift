//
//  CollectionViewAdapter+Event.swift
//  AlamofirePractice
//
//  Created by 이숭인 on 6/16/24.
//

import Foundation

extension CollectionViewAdapter {
    ///
    func updateDataSource(with identifier: String) {
        let snapshot = dataSource.snapshot()
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}
