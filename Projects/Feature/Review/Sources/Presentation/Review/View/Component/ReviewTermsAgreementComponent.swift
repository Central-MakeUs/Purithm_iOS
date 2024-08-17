//
//  ReviewTermsAgreementComponent.swift
//  Review
//
//  Created by 이숭인 on 8/11/24.
//

import Foundation

import UIKit
import CoreUIKit
import CoreCommonKit
import Combine

struct ReviewTermsAgreementComponentModel {
    let identifier: String
    let title: String
    let description: String
}

struct ReviewTermsAgreementComponent: Component {
    var identifier: String
    let title: String
    let description: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
        hasher.combine(description)
    }
}

extension ReviewTermsAgreementComponent {
    typealias ContentType = ReviewTermsAgreementView
    
    func render(content: ContentType, context: Self, cancellable: inout Set<AnyCancellable>) {
        content.configure(title: context.title, description: context.description)
    }
}

final class ReviewTermsAgreementView: BaseView {
    let titleLabel = PurithmLabel(typography: Constants.titleTypo)
    
    let container = UIView().then {
        $0.layer.cornerRadius = 12
        $0.backgroundColor = .white
    }
    let descriptionLabel = PurithmLabel(typography: Constants.descriptionTypo).then {
        $0.numberOfLines = 0
    }
    
    override func setup() {
        super.setup()
        
        self.backgroundColor = .gray100
    }
    
    override func setupSubviews() {
        addSubview(titleLabel)
        addSubview(container)
        
        container.addSubview(descriptionLabel)
    }
    
    override func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }
        
        container.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(20)
        }
    }
    
    func configure(title: String, description: String) {
        titleLabel.text = title
        descriptionLabel.text = description
    }
}

extension ReviewTermsAgreementView {
    private enum Constants {
        static let titleTypo = Typography(size: .size18, weight: .semibold, color: .gray500, applyLineHeight: true)
        static let descriptionTypo = Typography(size: .size14, weight: .medium, color: .gray200, applyLineHeight: true)
    }
}
