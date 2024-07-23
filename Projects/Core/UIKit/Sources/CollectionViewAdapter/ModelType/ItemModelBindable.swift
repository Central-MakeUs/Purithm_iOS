//
//  ItemModelBindable.swift
//  AlamofirePractice
//
//  Created by 이숭인 on 6/13/24.
//

import UIKit

public typealias ItemModelBindable = UICollectionViewCell & ItemModelBindableProtocol
public protocol ItemModelBindableProtocol {
    func bind(with itemModel: ItemModelType)
}

public protocol ModelType {
    var identifier: String { get }
    func hash(into hasher: inout Hasher)
}
