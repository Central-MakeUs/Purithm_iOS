//
//  FilterReviewItemComponent.swift
//  Filter
//
//  Created by 이숭인 on 8/5/24.
//

import UIKit
import CoreUIKit
import Combine

struct FilterReviewItemComponent: Component {
    var identifier: String
    let reviewItem: FilterReviewItemModel
    
    init(identifier: String, reviewItem: FilterReviewItemModel) {
        self.identifier = identifier
        self.reviewItem = reviewItem
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(reviewItem.thumbnailImageURLString)
        hasher.combine(reviewItem.author)
        hasher.combine(reviewItem.date)
        hasher.combine(reviewItem.satisfactionLevel)
    }
}

extension FilterReviewItemComponent {
    typealias ContentType = FilterReviewItemView
    
    func render(content: ContentType, context: Self, cancellable: inout Set<AnyCancellable>) {
        content.configure(with: context.reviewItem)
    }
}

final class FilterReviewItemView: BaseView {
    let thumbnailImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.backgroundColor = .gray300
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
    }
    
    let contentContainer = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.alignment = .fill
    }
    let textContainer = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fillProportionally
        $0.alignment = .leading
    }
    let authorLabel = PurithmLabel(typography: Constants.authorTypo)
    let dateLabel = PurithmLabel(typography: Constants.dateTypo)
    
    let rateContainer = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.alignment = .center
    }
    let rateImageView = UIImageView()
    let rateLabel = PurithmLabel(typography: Constants.rateTypo)
    
    override func setup() {
        super.setup()
        
        self.backgroundColor = .gray100
    }
    
    override func setupSubviews() {
        addSubview(thumbnailImageView)
        addSubview(contentContainer)
        
        contentContainer.addArrangedSubview(textContainer)
        textContainer.addArrangedSubview(authorLabel)
        textContainer.addArrangedSubview(dateLabel)
        
        contentContainer.addArrangedSubview(rateContainer)
        rateContainer.addArrangedSubview(rateImageView)
        rateContainer.addArrangedSubview(rateLabel)
    }
    
    override func setupConstraints() {
        thumbnailImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(self.snp.width).multipliedBy(1.25).priority(.high)
        }
        
        contentContainer.snp.makeConstraints { make in
            make.top.equalTo(thumbnailImageView.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        rateImageView.snp.makeConstraints { make in
            make.size.equalTo(20)
        }
    }
    
    func configure(with model: FilterReviewItemModel) {
        authorLabel.text = model.author
        dateLabel.text = model.date
        
        //TODO: Rate에 따라 이미지, 컬러가 달라짐
        rateImageView.image = model.satisfactionLevel.starImage .withTintColor(model.satisfactionLevel.color)
        rateLabel.text = "\(model.satisfactionLevel.rawValue) %"
        rateLabel.textColor = model.satisfactionLevel.color
        
        if let url = URL(string: model.thumbnailImageURLString) {
            thumbnailImageView.kf.setImage(with: url)
        }
    }
}

extension FilterReviewItemView {
    private enum Constants {
        static let authorTypo = Typography(size: .size21, weight: .medium, alignment: .left, color: .gray500, applyLineHeight: true)
        static let dateTypo = Typography(size: .size12, weight: .medium, alignment: .left, color: .gray300, applyLineHeight: true)
        static let rateTypo = Typography(size: .size18, weight: .semibold, color: .purple400, applyLineHeight: true)
    }
}

