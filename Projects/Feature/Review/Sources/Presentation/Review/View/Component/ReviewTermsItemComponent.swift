//
//  ReviewTermsItemComponent.swift
//  Review
//
//  Created by 이숭인 on 8/11/24.
//

import Foundation

import UIKit
import CoreUIKit
import CoreCommonKit
import Combine

struct ReviewTermsItemAction: ActionEventItem {
    let identifier: String
}

struct ReviewTermsItemComponentModel {
    let identifier: String
    let termsItem: ReviewTerms
    var isSelected: Bool
}

struct ReviewTermsItemComponent: Component {
    var identifier: String
    let termsModel: ReviewTermsItemComponentModel
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(termsModel.termsItem)
        hasher.combine(termsModel.isSelected)
    }
}

extension ReviewTermsItemComponent {
    typealias ContentType = ReviewTermsItemView
    
    func render(content: ContentType, context: Self, cancellable: inout Set<AnyCancellable>) {
        content.configure(with: context.termsModel)
        
        content.tapGesture.tapPublisher
            .sink { [weak content] _ in
                content?.actionEventEmitter.send(ReviewTermsItemAction(identifier: context.identifier))
            }
            .store(in: &cancellable)
    }
}

final class ReviewTermsItemView: BaseView, ActionEventEmitable {
    var actionEventEmitter = PassthroughSubject<ActionEventItem, Never>()
    
    let tapGesture = UITapGestureRecognizer()
    let imageView = UIImageView()
    let titleLabel = PurithmLabel(typography: Constants.titleTypo).then {
        $0.numberOfLines = 0
    }
    
    override func setup() {
        super.setup()
        
        self.backgroundColor = .gray100
    }
    
    override func setupSubviews() {
        [imageView, titleLabel].forEach {
            addSubview($0)
        }
        
        self.addGestureRecognizer(tapGesture)
        self.isUserInteractionEnabled = true
    }
    
    override func setupConstraints() {
        imageView.snp.makeConstraints { make in
            make.size.equalTo(24)
            make.leading.equalToSuperview()
            make.trailing.equalTo(titleLabel.snp.leading).offset(-10)
            make.centerY.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(imageView.snp.trailing).offset(10)
            make.verticalEdges.equalToSuperview().inset(10)
            make.trailing.equalToSuperview()
        }
    }
    
    func configure(with termsModel: ReviewTermsItemComponentModel) {
        imageView.image = termsModel.isSelected ? .icCheckboxPressed : .icCheckboxUnpressed
        titleLabel.text = termsModel.termsItem.title
    }
}

extension ReviewTermsItemView {
    private enum Constants {
        static let titleTypo = Typography(size: .size16, weight: .medium, color: .gray500, applyLineHeight: true)
    }
}
