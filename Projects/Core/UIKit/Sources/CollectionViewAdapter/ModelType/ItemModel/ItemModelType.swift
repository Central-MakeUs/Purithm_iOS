//
//  ItemModelType.swift
//  AlamofirePractice
//
//  Created by 이숭인 on 6/13/24.
//

import Foundation

public protocol ItemModelType: ModelType {
    var viewType: ViewType { get }
}

extension ItemModelType {
    // swiftlint:disable:next legacy_hashing
    public var hashValue: Int {
        var hasher = Hasher()
        innerHash(into: &hasher)
        return hasher.finalize()
    }
    
    func innerHash(into hasher: inout Hasher) {
        hasher.combine(identifier)
        hasher.combine(viewType.getIdentifier())
        
        hash(into: &hasher)
    }
}

public enum ViewType {
    case type(ItemModelBindable.Type)
    
    func getClass() -> AnyClass {
        guard case let .type(type) = self else { fatalError() }
        return type
    }
    
    func getIdentifier() -> String {
        guard case let .type(type) = self else { fatalError() }
        return String(describing: type)
    }
}
