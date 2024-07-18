//
//  ItemComponent.swift
//  Login
//
//  Created by 이숭인 on 7/18/24.
//

import UIKit
import Combine
import CoreUIKit
import CoreListKit

struct ItemComponent: Component {
    var identifier: String
    
    func hash(into hasher: inout Hasher) {
        
    }
}

extension ItemComponent {
    typealias ContentType = ItemView
    
    func render(content: ContentType, context: Self, cancellable: inout Set<AnyCancellable>) {
        
    }
}

final class ItemView: BaseView {
    let dummyView = UIView().then {
        $0.backgroundColor = .cyan
    }
    
    override func setupSubviews() {
        addSubview(dummyView)
    }
    
    override func setupConstraints() {
        dummyView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(32)
        }
    }
}

