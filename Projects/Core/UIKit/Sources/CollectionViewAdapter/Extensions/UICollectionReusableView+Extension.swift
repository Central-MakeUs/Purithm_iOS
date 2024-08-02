//
//  UICollectionReusableView+Extension.swift
//  AlamofirePractice
//
//  Created by 이숭인 on 6/15/24.
//

import UIKit
import Combine

private var prepareForReuseSubjectKey: UInt8 = 0

extension UICollectionReusableView {
    var prepareForReuseSubject: PassthroughSubject<Void, Never> {
        if let subject = objc_getAssociatedObject(self, &prepareForReuseSubjectKey) as? PassthroughSubject<Void, Never> {
            return subject
        } else {
            let subject = PassthroughSubject<Void, Never>()
            objc_setAssociatedObject(self, &prepareForReuseSubjectKey, subject, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return subject
        }
    }
    
    @objc func swizzled_prepareForReuse() {
        prepareForReuseSubject.send(())
        swizzled_prepareForReuse()
    }
    
    public static func swizzlePrepareForReuse() {
        let originalSelector = #selector(UICollectionReusableView.prepareForReuse)
        let swizzledSelector = #selector(UICollectionReusableView.swizzled_prepareForReuse)
        
        guard let originalMethod = class_getInstanceMethod(UICollectionReusableView.self, originalSelector),
              let swizzledMethod = class_getInstanceMethod(UICollectionReusableView.self, swizzledSelector) else { return }
        
        method_exchangeImplementations(originalMethod, swizzledMethod)
    }
}
