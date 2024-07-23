//
//  ItemComponent.swift
//  Login
//
//  Created by 이숭인 on 7/18/24.
//

import UIKit
import Combine
import CoreUIKit
import CoreCommonKit

struct ItemComponent: Component {
    var identifier: String
    let consentType: ConsentItemType
    let isSelected: Bool
    
    init(identifier: String, type: ConsentItemType, isSelected: Bool) {
        self.identifier = identifier
        self.consentType = type
        self.isSelected = isSelected
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(consentType)
        hasher.combine(isSelected)
    }
}

extension ItemComponent {
    typealias ContentType = ItemView
    
    func render(content: ContentType, context: Self, cancellable: inout Set<AnyCancellable>) {
        content.backgroundColor = .clear
        
        content.configure(
            title: context.consentType.rawValue,
            isSelected: context.isSelected
        )
    }
}

final class ItemView: BaseView {
    let iconImageView = UIImageView()
    let titleLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        $0.textColor = .gray500
    }
    
    override func setupSubviews() {
        [iconImageView, titleLabel].forEach {
            addSubview($0)
        }
    }
    
    override func setupConstraints() {
        iconImageView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(8)
            make.leading.equalToSuperview()
            make.size.equalTo(24)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconImageView.snp.trailing).offset(12)
            make.trailing.equalToSuperview()
            make.verticalEdges.equalToSuperview()
        }
    }
    
    func configure(title: String, isSelected: Bool) {
        titleLabel.text = title
        iconImageView.image = isSelected ? . icCheckboxPressed : .icCheckboxUnpressed
    }
}

