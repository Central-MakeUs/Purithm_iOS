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

struct TermsAndConditionItemAction: ActionEventItem {
    let identifier: String
}

struct TermsAndConditionItemComponent: Component {
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

extension TermsAndConditionItemComponent {
    typealias ContentType = ItemView
    
    func render(content: ContentType, context: Self, cancellable: inout Set<AnyCancellable>) {
        content.backgroundColor = .clear
        
        content.configure(
            title: context.consentType.rawValue,
            isSelected: context.isSelected
        )
        
        content.rightButton.tapPublisher
            .sink { [weak content] _ in
                content?.actionEventEmitter.send(TermsAndConditionItemAction(identifier: context.identifier))
            }
            .store(in: &cancellable)
    }
}

final class ItemView: BaseView, ActionEventEmitable {
    var actionEventEmitter = PassthroughSubject<ActionEventItem, Never>()
    
    let iconImageView = UIImageView()
    let titleLabel = UILabel(typography: Constants.noticeTypo)
    let rightButton = UIButton().then {
        $0.setImage(.icArrowRight.withTintColor(.gray300), for: .normal)
    }
    
    override func setupSubviews() {
        [iconImageView, titleLabel, rightButton].forEach {
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
        
        rightButton.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(8)
            make.trailing.equalToSuperview()
            make.size.equalTo(24)
        }
    }
    
    func configure(title: String, isSelected: Bool) {
        titleLabel.text = title
        iconImageView.image = isSelected ? . icCheckboxPressed : .icCheckboxUnpressed
    }
}

extension ItemView {
    enum Constants {
        static let noticeTypo = Typography(size: .size16, weight: .medium, color: .gray500, applyLineHeight: true)
    }
}
