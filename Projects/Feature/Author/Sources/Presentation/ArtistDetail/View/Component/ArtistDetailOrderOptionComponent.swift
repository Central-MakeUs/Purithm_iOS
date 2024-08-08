//
//  ArtistDetailOrderOptionComponent.swift
//  Author
//
//  Created by 이숭인 on 8/9/24.
//

import UIKit
import CoreUIKit
import CoreCommonKit
import Combine

struct ArtistDetailOrderOptionAction: ActionEventItem {
    let identifier: String
}


struct ArtistDetailOrderOptionComponent: Component {
    var identifier: String
    let filterCount: Int
    let optionTitle: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(filterCount)
        hasher.combine(optionTitle)
    }
}

extension ArtistDetailOrderOptionComponent {
    typealias ContentType = ArtistDetailOrderOptionView
    
    func render(content: ContentType, context: Self, cancellable: inout Set<AnyCancellable>) {
        content.configure(count: context.filterCount, optionTitle: context.optionTitle)
        
        content.containerTapGesture.tapPublisher
            .sink { [weak content] _ in
                let action = ArtistDetailOrderOptionAction(identifier: context.identifier)
                content?.actionEventEmitter.send(action)
            }
            .store(in: &cancellable)
    }
}

final class ArtistDetailOrderOptionView: BaseView, ActionEventEmitable {
    var actionEventEmitter = PassthroughSubject<ActionEventItem, Never>()
    
    let container = UIView().then {
        $0.isUserInteractionEnabled = true
    }
    let containerTapGesture = UITapGestureRecognizer()
    
    let reviewCountLabel = PurithmLabel(typography: Constants.reviewTitleTypo)
    
    let orderLabel = PurithmLabel(typography: Constants.orderTypo)
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
        
        [reviewCountLabel, orderLabel, downImageView].forEach {
            container.addSubview($0)
        }
    }
    
    override func setupConstraints() {
        container.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(20)
        }
        
        reviewCountLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.verticalEdges.lessThanOrEqualToSuperview()
            make.trailing.lessThanOrEqualTo(orderLabel.snp.leading).offset(-12)
        }
        
        orderLabel.snp.makeConstraints { make in
            make.verticalEdges.lessThanOrEqualToSuperview()
            make.trailing.equalTo(downImageView.snp.leading).offset(-4)
            make.leading.lessThanOrEqualTo(reviewCountLabel.snp.trailing).offset(12)
        }
        
        downImageView.snp.makeConstraints { make in
            make.size.equalTo(16)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
        }
    }
    
    func configure(count: Int, optionTitle: String) {
        reviewCountLabel.text = "\(count)개의 필터"
        orderLabel.text = optionTitle
    }
}

extension ArtistDetailOrderOptionView {
    private enum Constants {
        static let reviewTitleTypo = Typography(size: .size16, weight: .semibold, color: .gray500, applyLineHeight: true)
        static let orderTypo = Typography(size: .size14, weight: .semibold, color: .gray400, applyLineHeight: true)
    }
}
