//
//  DividerComponent.swift
//  CoreUIKit
//
//  Created by 이숭인 on 8/22/24.
//

import Foundation

import UIKit
import CoreCommonKit
import Combine
import SnapKit
import Then

public struct DividerComponent: Component {
    public var identifier: String
    
    public init(identifier: String) {
        self.identifier = identifier
    }
    
    public func hash(into hasher: inout Hasher) {
        
    }
}

extension DividerComponent {
    public typealias ContentType = DividerView
    
    public func render(content: ContentType, context: Self, cancellable: inout Set<AnyCancellable>) {
        
    }
}

public final class DividerView: BaseView {
    let divider = UIView().then {
        $0.backgroundColor = .gray200
    }
    
    public override func setup() {
        super.setup()
        
        self.backgroundColor = .gray100
    }
    
    public override func setupSubviews() {
        addSubview(divider)
    }
    
    public override func setupConstraints() {
        divider.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(20)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(1)
        }
    }
}

