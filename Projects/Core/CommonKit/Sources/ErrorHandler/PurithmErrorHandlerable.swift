//
//  PurithmErrorHandlerable.swift
//  CoreCommonKit
//
//  Created by 이숭인 on 8/3/24.
//

import UIKit
import Combine

public protocol PurithmErrorHandlerable where Self: UIViewController {
    var cancellables: Set<AnyCancellable> { get set }
    var errorPublisher: AnyPublisher<Error, Never> { get }
    func bindErrorHandler()
    func presentErrorPopup(with error: Error)
}
