//
//  FilterOrderOptionComponent.swift
//  Filter
//
//  Created by 이숭인 on 7/28/24.
//

import UIKit
import CoreUIKit
import Combine

struct FilterOrderOptionAction: ActionEventItem {
    let identifier: String
}

struct FilterOrderOptionComponent: Component {
    var identifier: String
    let optionTitle: String
    
    init(identifier: String, optionTitle: String) {
        self.identifier = identifier
        self.optionTitle = optionTitle
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(optionTitle)
    }
}

extension FilterOrderOptionComponent {
    typealias ContentType = FilterOrderOptionView
    
    func render(content: ContentType, context: Self, cancellable: inout Set<AnyCancellable>) {
        content.configure(with: context.optionTitle)
        content.containerTapGesture.tapPublisher
            .sink { [weak content] _ in
                let action = FilterOrderOptionAction(identifier: context.identifier)
                content?.actionEventEmitter.send(action)
            }
            .store(in: &cancellable)
    }
}

final class FilterOrderOptionView: BaseView, ActionEventEmitable {
    var actionEventEmitter = PassthroughSubject<ActionEventItem, Never>()
    
    let container = UIView()
    let containerTapGesture = UITapGestureRecognizer()
    
    let optionLabel = UILabel(typography: Constants.optionTitleTypo)
    let downImageView = UIImageView().then {
        $0.image = .icArrowBottom.withTintColor(.gray400)
    }
    
    override func setup() {
        super.setup()
        self.backgroundColor = .gray100
        
        container.addGestureRecognizer(containerTapGesture)
    }
    
    override func setupSubviews() {
        addSubview(container)
        
        container.addSubview(optionLabel)
        container.addSubview(downImageView)
    }
    
    override func setupConstraints() {
        container.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(20)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(20)
        }
        
        optionLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(downImageView.snp.leading).offset(-4)
        }
        
        downImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.size.equalTo(16)
            make.trailing.equalToSuperview().inset(20)
        }
    }
    
    func configure(with title: String) {
        optionLabel.text = title
    }
}

extension FilterOrderOptionView {
    private enum Constants {
        static let optionTitleTypo = Typography(size: .size14, weight: .semibold, color: .gray400, applyLineHeight: true)
    }
}
