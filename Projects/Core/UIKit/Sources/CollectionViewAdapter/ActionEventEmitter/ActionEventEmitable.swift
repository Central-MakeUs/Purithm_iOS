//
//  ActionEventEmitable.swift
//  AlamofirePractice
//
//  Created by 이숭인 on 6/14/24.
//

import Combine

public protocol ActionEventEmitable {
    var actionEventEmitter: PassthroughSubject<ActionEventItem, Never> { get }
}

public protocol ActionEventItem { }
