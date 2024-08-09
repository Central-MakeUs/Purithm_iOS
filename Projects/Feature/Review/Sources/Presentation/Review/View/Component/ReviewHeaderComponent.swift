//
//  ReviewHeaderComponent.swift
//  Review
//
//  Created by 이숭인 on 8/9/24.
//

import UIKit
import CoreUIKit
import CoreCommonKit
import Combine
import Kingfisher

struct ReviewHeaderComponentModel {
    let identifier: String
    let title: String
    let description: String
    let thumbnailURLString: String
    let satisfactionLevel: SatisfactionLevel
}

struct ReviewHeaderComponent: Component {
    var identifier: String
    let headerModel: ReviewHeaderComponentModel
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(headerModel.title)
        hasher.combine(headerModel.description)
        hasher.combine(headerModel.thumbnailURLString)
        hasher.combine(headerModel.satisfactionLevel)
    }
}

extension ReviewHeaderComponent {
    typealias ContentType = ReviewHeaderView
    
    func render(content: ContentType, context: Self, cancellable: inout Set<AnyCancellable>) {
        content.configure(with: context.headerModel)
    }
}

final class ReviewHeaderView: BaseView {
    let container = UIView()
    let backgroundImageView = UIImageView()
    
    let filterThumbnailView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 100 / 2
        $0.clipsToBounds = true
    }
    
    let textContainer = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fillProportionally
        $0.alignment = .center
    }
    let titleLabel = PurithmLabel(typography: Constants.titleTypo)
    let descriptionLabel = PurithmLabel(typography: Constants.descriptionTypo)
    
    override func setupSubviews() {
        [backgroundImageView, container].forEach {
            addSubview($0)
        }
        
        [filterThumbnailView, textContainer].forEach {
            container.addSubview($0)
        }
        
        textContainer.addArrangedSubview(titleLabel)
        textContainer.addArrangedSubview(descriptionLabel)
    }
    
    override func setupConstraints() {
        container.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        filterThumbnailView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(40)
            make.centerX.equalToSuperview()
            make.size.equalTo(100)
        }
        
        textContainer.snp.makeConstraints { make in
            make.top.equalTo(filterThumbnailView.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    func configure(with headerModel: ReviewHeaderComponentModel) {
        titleLabel.text = headerModel.title
        descriptionLabel.text = headerModel.description
        backgroundImageView.image = headerModel.satisfactionLevel.backgroundSatisfactionImage
        
        if let url = URL(string: headerModel.thumbnailURLString) {
            filterThumbnailView.kf.setImage(with: url)
        }
    }
}

extension ReviewHeaderView {
    private enum Constants {
        static let titleTypo = Typography(size: .size30, weight: .semibold, alignment: .center, color: .gray500, applyLineHeight: true)
        static let descriptionTypo = Typography(size: .size14, weight: .medium, alignment: .center, color: .gray400, applyLineHeight: true)
    }
}

