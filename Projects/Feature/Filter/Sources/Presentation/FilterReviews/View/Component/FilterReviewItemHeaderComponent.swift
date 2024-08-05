//
//  FilterReviewItemHeaderComponent.swift
//  Filter
//
//  Created by 이숭인 on 8/5/24.
//

import UIKit
import CoreUIKit
import CoreCommonKit
import Combine

struct FilterReviewItemHeaderComponent: Component {
    var identifier: String
    let reviewCount: Int
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(reviewCount)
    }
}

extension FilterReviewItemHeaderComponent {
    typealias ContentType = FilterReviewItemHeaderView
    
    func render(content: ContentType, context: Self, cancellable: inout Set<AnyCancellable>) {
        content.configure(with: context.reviewCount)
    }
}

final class FilterReviewItemHeaderView: BaseView {
    let label = PurithmLabel(typography: Constants.labelTypo)
    
    override func setup() {
        super.setup()
        self.backgroundColor = .gray100
    }
    
    override func setupSubviews() {
        addSubview(label)
    }
    
    override func setupConstraints() {
        label.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(40)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    func configure(with count: Int) {
        label.text = "\(count)명이 후기를 남겼어요"
    }
}

extension FilterReviewItemHeaderView {
    private enum Constants {
        static let labelTypo = Typography(size: .size16, weight: .semibold, color: .gray500, applyLineHeight: true)
    }
}

