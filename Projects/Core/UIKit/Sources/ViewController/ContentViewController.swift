//
//  ContentViewController.swift
//  CoreUIKit
//
//  Created by 이숭인 on 7/16/24.
//

import UIKit

open class ContentViewController<ContentView: UIView>: UIViewController {
    public typealias ContentViewType = ContentView
    
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var contentView: ContentView {
        view as! ContentView
    }
    
    open override func loadView() {
        view = ContentView(frame: .zero)
    }
}
