//
//  UIButton+Color.swift
//  CoreUIKit
//
//  Created by 이숭인 on 7/24/24.
//

import UIKit

extension UIButton {
    public func setBackgroundColor(_ color: UIColor, for state: UIControl.State) {
        let minimumSize: CGSize = CGSize(width: 1.0, height: 1.0)
        
        UIGraphicsBeginImageContext(minimumSize)
        if let context = UIGraphicsGetCurrentContext() {
            context.setFillColor(color.cgColor)
            context.fill(CGRect(origin: .zero, size: minimumSize))
        }
        
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.setBackgroundImage(colorImage, for: state)
    }
    
    public func round(with radius: CGFloat) {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = radius
    }
}
