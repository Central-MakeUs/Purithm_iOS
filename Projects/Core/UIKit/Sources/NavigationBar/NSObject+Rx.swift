//
//  NSObject+Rx.swift
//  CoreUIKit
//
//  Created by 이숭인 on 7/23/24.
//

import UIKit
import RxSwift

extension Reactive where Base: UIViewController {

    public var viewWillAppear: Observable<Bool> {
        return methodInvoked(#selector(Base.viewWillAppear(_:)))
            .map { $0.first as? Bool ?? false }
    }

    public var viewDidAppear: Observable<Bool> {
        return methodInvoked(#selector(Base.viewDidAppear(_:)))
            .map { $0.first as? Bool ?? false }
    }

    public var viewWillDisappear: Observable<Bool> {
        return methodInvoked(#selector(Base.viewWillDisappear(_:)))
            .map { $0.first as? Bool ?? false }
    }

    public var viewDidDisappear: Observable<Bool> {
        return methodInvoked(#selector(Base.viewDidDisappear(_:)))
            .map { $0.first as? Bool ?? false }
    }
}

fileprivate var disposeBagContext: UInt8 = 0

extension Reactive where Base: AnyObject {
    func synchronizedBag<T>( _ action: () -> T) -> T {
        objc_sync_enter(self.base)
        let result = action()
        objc_sync_exit(self.base)
        return result
    }
}

public extension Reactive where Base: AnyObject {

    /// a unique DisposeBag that is related to the Reactive.Base instance only for Reference type
    var disposeBag: DisposeBag {
        get {
            return synchronizedBag {
                if let disposeObject = objc_getAssociatedObject(base, &disposeBagContext) as? DisposeBag {
                    return disposeObject
                }
                let disposeObject = DisposeBag()
                objc_setAssociatedObject(base, &disposeBagContext, disposeObject, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return disposeObject
            }
        }
        
        set {
            synchronizedBag {
                objc_setAssociatedObject(base, &disposeBagContext, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
}
