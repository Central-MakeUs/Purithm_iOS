//
//  NSDirectionalEdgeInsets+Extension.swift
//  AlamofirePractice
//
//  Created by 이숭인 on 6/18/24.
//

import UIKit


public extension NSDirectionalEdgeInsets {
    var horizontal: CGFloat { self.leading + self.trailing }
    var vertical: CGFloat { self.top + self.bottom }
}

public extension NSDirectionalEdgeInsets {
    init(vertical: CGFloat, horizontal: CGFloat) {
        self.init(top: vertical, leading: horizontal, bottom: vertical, trailing: horizontal)
    }
    
    static func with(top: CGFloat = 0, leading: CGFloat = 0, bottom: CGFloat = 0, trailing: CGFloat = 0) -> NSDirectionalEdgeInsets {
        NSDirectionalEdgeInsets(top: top, leading: leading, bottom: bottom, trailing: trailing)
    }
    
    static func with(vertical: CGFloat = 0, horizontal: CGFloat = 0) -> NSDirectionalEdgeInsets {
        NSDirectionalEdgeInsets(top: vertical, leading: horizontal, bottom: vertical, trailing: horizontal)
    }
}
