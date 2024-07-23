//
//  Component.swift
//  AlamofirePractice
//
//  Created by 이숭인 on 6/13/24.
//

import Foundation

import UIKit
import Combine

public protocol Component: ItemModelType {
    associatedtype Content: UIView
    associatedtype Context: Component
    
    var viewType: ViewType { get }
    
    func createContent() -> Content
    func prepareForReuse(content: Content)
    func render(content: Content, context: Context)
    func render(content: Content, context: Context, cancellable: inout Set<AnyCancellable>)
}

//MARK: - ViewType
extension Component {
    public var viewType: ViewType { .type(ComponentContainerCell<Context>.self) }
}

//MARK: - Render
extension Component {
    public func createContent() -> Content { Content() }
    public func prepareForReuse(content: Content) { }
    public func render(content: Content, context: Context) { }
    public func fender(content: Content, context: Context, cancellable: inout Set<AnyCancellable>) {
        render(content: content, context: context)
    }
}
