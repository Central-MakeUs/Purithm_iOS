//
//  ReviewRemoveButtonComponent.swift
//  Review
//
//  Created by 이숭인 on 8/12/24.
//

import UIKit
import CoreUIKit
import CoreCommonKit
import Combine

struct ReviewRemoveButtonAction: ActionEventItem {
    let identifier: String
}

struct ReviewRemoveButtonComponent: Component {
    var identifier: String
    
    func hash(into hasher: inout Hasher) {
        
    }
}

extension ReviewRemoveButtonComponent {
    typealias ContentType = ReviewRemoveButtonView
    
    func render(content: ContentType, context: Self, cancellable: inout Set<AnyCancellable>) {
        content.button.tap
            .sink { [weak content] _ in
                content?.actionEventEmitter.send(ReviewRemoveButtonAction(identifier: context.identifier))
            }
            .store(in: &cancellable)
    }
}

final class ReviewRemoveButtonView: BaseView, ActionEventEmitable {
    var actionEventEmitter = PassthroughSubject<ActionEventItem, Never>()
    
    let button = UIButton().then {
        $0.setTitle("삭제", for: .normal)
        $0.setTitleColor(.gray300, for: .normal)
        $0.setTitleColor(.gray400, for: .selected)
        
        $0.titleLabel?.font = UIFont.Pretendard.semiBold.font(size: 16)
        $0.setBackgroundColor(.white, for: .normal)
        $0.setBackgroundColor(.gray200, for: .disabled)
        $0.setBackgroundColor(.gray200, for: .highlighted)
    }
    
    override func setupSubviews() {
        self.layer.cornerRadius = 12
        self.clipsToBounds = true
        
        addSubview(button)
    }
    
    override func setupConstraints() {
        button.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

