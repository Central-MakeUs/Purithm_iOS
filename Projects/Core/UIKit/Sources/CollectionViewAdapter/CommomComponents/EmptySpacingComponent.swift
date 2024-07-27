//
//  EmptySpacingComponent.swift
//
//  Created by 이숭인 on 7/23/24.
//

import UIKit
import Combine
import SnapKit
import Then
import CoreCommonKit

public struct EmptySpacingComponent: Component {
    public var identifier: String
    let height: CGFloat
    
    public init(identifier: String, height: CGFloat) {
        self.identifier = identifier
        self.height = height
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(height)
    }
}

extension EmptySpacingComponent {
    public typealias ContentType = EmptySpacingView
    
    public func render(content: ContentType, context: Self, cancellable: inout Set<AnyCancellable>) {
        content.configure(height: context.height)
    }
}

public final class EmptySpacingView: BaseView {
    private let emptyView = UIView().then {
        $0.backgroundColor = .gray100
    }
    
    public override func setupSubviews() {
        addSubview(emptyView)
    }
    
    public override func setupConstraints() {
        emptyView.snp.makeConstraints { make in
            make.height.equalTo(0)
            make.edges.equalToSuperview()
        }
    }
    
    fileprivate func configure(height: CGFloat) {
        DispatchQueue.main.async { [weak self] in
            self?.emptyView.snp.updateConstraints { make in
                make.height.equalTo(height)
            }
        }
    }
}


