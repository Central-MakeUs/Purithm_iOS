//
//  FilterItemComponent.swift
//  CoreUIKit
//
//  Created by 이숭인 on 8/9/24.
//

import UIKit
import CoreCommonKit
import SnapKit
import Then
import Combine
import Kingfisher

public struct FilterLikeAction: ActionEventItem {
    public let identifier: String
}

public struct FilterDidTapAction: ActionEventItem {
    public let identifier: String
}

public struct FilterItemComponent: Component {
    public var identifier: String
    let item: FilterItemModel
    
    public init(identifier: String, item: FilterItemModel) {
        self.identifier = identifier
        self.item = item
    }
    
    public func prepareForReuse(content: FilterItemView) {
        content.premiumFilterView.isHidden = true
        content.premiumBadgeView.isHidden = true
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(item.filterImageURLString)
        hasher.combine(item.planType)
        hasher.combine(item.filterTitle)
        hasher.combine(item.author)
        hasher.combine(item.likeCount)
        hasher.combine(item.isLike)
    }
}

extension FilterItemComponent {
    public typealias ContentType = FilterItemView
    
    public func render(content: ContentType, context: Self, cancellable: inout Set<AnyCancellable>) {
        content.configure(with: context.item)
        
        content.imageTapGesture.tapPublisher
            .sink { [weak content] _ in
                content?.actionEventEmitter.send(FilterDidTapAction(identifier: context.identifier))
            }
            .store(in: &cancellable)
        
        content.likeButton.tap
            .sink { [weak content] _ in
                content?.actionEventEmitter.send(FilterLikeAction(identifier: context.identifier))
            }
            .store(in: &cancellable)
    }
}

public final class FilterItemView: BaseView, ActionEventEmitable {
    public let actionEventEmitter = PassthroughSubject<ActionEventItem, Never>()
    
    let topContainer = UIView().then {
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
    }
    let filterImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.backgroundColor = .gray200
        $0.kf.indicatorType = .activity
    }
    let imageTapGesture = UITapGestureRecognizer()
    
    let premiumFilterView = FilterPremiumFilterView()
    let premiumBadgeView = FilterPremiumBadgeView()
    
    let bottomContainer = UIView()
    let filterTitleLabel = PurithmLabel(typography: Constants.titleTypo)
    let authorLabel = PurithmLabel(typography: Constants.authorTypo)
    let likeButton = UIButton().then {
        $0.setImage(.icLikeUnpressed.withTintColor(.gray200), for: .normal)
        $0.setImage(.icLikePressed.withTintColor(.blue400), for: .selected)
        
        $0.imageView?.contentMode = .scaleAspectFill
    }
    let likeCountLabel = PurithmLabel(typography: Constants.countTypo)
    
    public override func setup() {
        super.setup()
        
        self.backgroundColor = .gray100
        topContainer.addGestureRecognizer(imageTapGesture)
    }
    
    deinit {
        print("filterItemView deinit")
    }
    
    public override func setupSubviews() {
        [topContainer, bottomContainer].forEach {
            addSubview($0)
        }
        
        [filterImageView, premiumFilterView, premiumBadgeView].forEach {
            topContainer.addSubview($0)
        }
        
        [filterTitleLabel, authorLabel, likeButton, likeCountLabel].forEach {
            bottomContainer.addSubview($0)
        }
    }
    
    public override func setupConstraints() {
        topContainer.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(topContainer.snp.width).multipliedBy(1.25)
        }
        
        filterImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        premiumFilterView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        premiumBadgeView.snp.makeConstraints { make in
            make.top.equalTo(filterImageView.snp.top).offset(10)
            make.trailing.equalTo(filterImageView.snp.trailing).offset(-10)
            make.height.equalTo(24)
        }
        
        bottomContainer.snp.makeConstraints { make in
            make.top.equalTo(topContainer.snp.bottom).offset(4)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        filterTitleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
            make.trailing.equalTo(likeButton.snp.leading).offset(-8)
        }
        
        likeButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.bottom.equalTo(likeCountLabel.snp.top)
            make.size.equalTo(28)
        }
        
        authorLabel.snp.makeConstraints { make in
            make.top.equalTo(filterTitleLabel.snp.bottom)
            make.bottom.leading.equalToSuperview()
            make.trailing.equalTo(likeCountLabel.snp.leading).offset(-8)
        }
        
        likeCountLabel.snp.makeConstraints { make in
            make.centerY.equalTo(authorLabel)
            make.centerX.equalTo(likeButton.snp.centerX)
            make.bottom.equalToSuperview()
        }
    }
    
    public func configure(with item: FilterItemModel) {
        premiumFilterView.isHidden = item.canAccess
        premiumBadgeView.isHidden = !item.canAccess
        
        if item.canAccess {
            premiumBadgeView.configure(with: item.planType)
        } else {
            premiumFilterView.isHidden = item.planType == .free
            premiumFilterView.configure(with: item.planType)
        }
        
        if let url = URL(string: item.filterImageURLString) {
            filterImageView.kf.setImage(with: url)
        }
        
        filterTitleLabel.text = item.filterTitle
        filterTitleLabel.font = UIFont.EBGaramond.medium.font(size: 24)
        authorLabel.text = "Made by \(item.author)"
        likeCountLabel.text = "\(item.likeCount)"
        likeButton.isSelected = item.isLike
    }
}

extension FilterItemView {
    private enum Constants {
        static let titleTypo = Typography(size: .size24, weight: .medium, color: .gray500, applyLineHeight: true)
        static let authorTypo = Typography(size: .size12, weight: .medium, color: .gray300, applyLineHeight: true)
        static let countTypo = Typography(size: .size12, weight: .medium, color: .gray200, applyLineHeight: true)
    }
}
