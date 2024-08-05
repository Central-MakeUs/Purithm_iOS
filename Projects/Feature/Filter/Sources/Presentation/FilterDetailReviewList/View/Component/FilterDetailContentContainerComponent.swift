//
//  FilterDetailContentContainerComponent.swift
//  Filter
//
//  Created by 이숭인 on 8/5/24.
//

import UIKit
import CoreUIKit
import Combine

struct FilterDetailContentContainerComponent: Component {
    var identifier: String
    let reviewModel: FilterDetailReviewModel
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(reviewModel.author)
        hasher.combine(reviewModel.authorProfileURL)
        hasher.combine(reviewModel.content)
        hasher.combine(reviewModel.imageURLStrings)
        hasher.combine(reviewModel.satisfactionLevel)
    }
}

extension FilterDetailContentContainerComponent {
    typealias ContentType = FilterDetailContentContainerView
    
    func render(content: ContentType, context: Self, cancellable: inout Set<AnyCancellable>) {
        content.configure(with: context.reviewModel)
    }
}

final class FilterDetailContentContainerView: BaseView {
    let descriptionLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.textColor = .black
    }
    
    override func setupSubviews() {
        addSubview(descriptionLabel)
    }
    
    override func setupConstraints() {
        descriptionLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configure(with reviewModel: FilterDetailReviewModel) {
        descriptionLabel.text = reviewModel.content
    }
}

