//
//  ProfileFilterCardComponent.swift
//  Profile
//
//  Created by 이숭인 on 8/22/24.
//

import UIKit
import CoreUIKit
import CoreCommonKit
import Combine

struct ProfileCardReviewAction: ActionEventItem {
    let filterID: String
    let reviewID: String
    let hasReview: Bool
}

struct ProfileCardFilterAction: ActionEventItem {
    let filterID: String
    let filterName: String
}

struct ProfileCardImageAction: ActionEventItem {
    let filterID: String
}

struct ProfileFilterCardComponent: Component {
    var identifier: String
    let model: ProfileFilterCardModel
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(model.thumbnailURLString)
        hasher.combine(model.author)
        hasher.combine(model.createdAt)
        hasher.combine(model.filterId)
        hasher.combine(model.filterName)
        hasher.combine(model.hasReview)
        hasher.combine(model.planType)
        hasher.combine(model.reviewId)
    }
}

extension ProfileFilterCardComponent {
    typealias ContentType = ProfileFilterCardView
    
    func render(content: ContentType, context: Self, cancellable: inout Set<AnyCancellable>) {
        content.configure(with: context.model)
        
        content.leftButton.tap
            .sink { [weak content] _ in
                content?.actionEventEmitter.send(ProfileCardReviewAction(
                    filterID: context.model.filterId,
                    reviewID: context.model.reviewId,
                    hasReview: context.model.hasReview
                ))
            }
            .store(in: &cancellable)
        
        content.rightButton.tap
            .sink { [weak content] _ in
                content?.actionEventEmitter.send(ProfileCardFilterAction(
                    filterID: context.model.filterId, 
                    filterName: context.model.filterName
                ))
            }
            .store(in: &cancellable)
        
        content.imageTapGesture.tapPublisher
            .sink { [weak content] _ in
                content?.actionEventEmitter.send(ProfileCardImageAction(
                    filterID: context.model.filterId
                ))
            }
            .store(in: &cancellable)
    }
}

final class ProfileFilterCardView: BaseView, ActionEventEmitable {
    var actionEventEmitter = PassthroughSubject<ActionEventItem, Never>()
    
    let container = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
    }
    
    let filterTitleContainer = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fillProportionally
        $0.alignment = .leading
        $0.spacing = 5
    }
    
    let badgeView = FilterPlanBadgeView()
    let filterLabel = PurithmLabel(typography: Constants.filterTypo)
    let authorLabel = PurithmLabel(typography: Constants.authorTypo)
    
    let thumbnailImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
        $0.image = .placeholderSquareLg
        $0.isUserInteractionEnabled = true
    }
    let imageTapGesture = UITapGestureRecognizer()
    
    let buttonContainer = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.alignment = .fill
    }
    let leftButton = UIButton().then {
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.gray100.cgColor
        $0.setTitleColor(.gray300, for: .normal)
        $0.titleLabel?.font = UIFont.Pretendard.semiBold.font(size: 16)
    }
    let rightButton = UIButton().then {
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.gray100.cgColor
        $0.setTitleColor(.blue400, for: .normal)
        $0.titleLabel?.font = UIFont.Pretendard.semiBold.font(size: 16)
    }
    
    override func setup() {
        super.setup()
        
        self.layer.cornerRadius = 12
        self.clipsToBounds = true
        
        thumbnailImageView.addGestureRecognizer(imageTapGesture)
    }
    
    override func setupSubviews() {
        addSubview(container)
        
        container.addSubview(filterTitleContainer)
        filterTitleContainer.addArrangedSubview(badgeView)
        filterTitleContainer.addArrangedSubview(filterLabel)
        filterTitleContainer.addArrangedSubview(authorLabel)
        
        container.addSubview(thumbnailImageView)
        
        container.addSubview(buttonContainer)
        buttonContainer.addArrangedSubview(leftButton)
        buttonContainer.addArrangedSubview(rightButton)
    }
    
    override func setupConstraints() {
        container.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        filterTitleContainer.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.leading.equalToSuperview().inset(20)
            make.trailing.equalTo(thumbnailImageView.snp.leading).offset(-20)
        }
        
        badgeView.snp.makeConstraints { make in
            make.height.equalTo(24)
        }
        
        thumbnailImageView.snp.makeConstraints { make in
            make.size.equalTo(58)
            make.top.equalToSuperview().inset(20)
            make.trailing.equalToSuperview().inset(20)
        }
        
        buttonContainer.snp.makeConstraints { make in
            make.top.equalTo(filterTitleContainer.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        leftButton.snp.makeConstraints { make in
            make.height.equalTo(56)
        }
        
        rightButton.snp.makeConstraints { make in
            make.height.equalTo(56)
        }
    }
    
    func configure(with model: ProfileFilterCardModel) {
        badgeView.configure(with: model.planType)
        
        filterLabel.text = model.filterName
        filterLabel.font = UIFont.EBGaramond.semiBold.font(size: 28)
        
        authorLabel.text = "Made by \(model.author)"
        
        let leftTitle = model.hasReview ? "남긴 후기" : "후기 남기기"
        leftButton.setTitle(leftTitle, for: .normal)
        rightButton.setTitle("필터값 보기", for: .normal)
        
        if let url = URL(string: model.thumbnailURLString) {
            thumbnailImageView.kf.setImage(with: url, placeholder: UIImage.placeholderSquareLg)
        }
    }
}

extension ProfileFilterCardView {
    private enum Constants {
        static let filterTypo = Typography(size: .size28, weight: .medium, color: .gray500, applyLineHeight: true)
        static let authorTypo = Typography(size: .size12, weight: .medium, color: .gray300, applyLineHeight: true)
    }
}


extension ProfileFilterCardView {
    class FilterPlanBadgeView: BaseView {
        let label = PurithmLabel(typography: Constants.titleTypo)
        
        override func setup() {
            super.setup()
            
            self.layer.cornerRadius = 24 / 2
            self.layer.borderWidth = 1
        }
        
        override func setupSubviews() {
            addSubview(label)
        }
        
        override func setupConstraints() {
            label.snp.makeConstraints { make in
                make.verticalEdges.equalToSuperview()
                make.horizontalEdges.equalToSuperview().inset(8)
            }
        }
        
        func configure(with planType: PlanType) {
            label.text = planType.title
            
            switch planType {
            case .free:
                label.textColor = .gray400
                self.layer.borderColor = UIColor.blue100.cgColor
            case .premium:
                label.textColor = .blue400
                self.layer.borderColor = UIColor.blue400.cgColor
            case .premiumPlus:
                label.textColor = .purple500
                self.layer.borderColor = UIColor.purple500.cgColor
            }
        }
    }
}

extension ProfileFilterCardView.FilterPlanBadgeView {
    private enum Constants {
        static let titleTypo = Typography(size: .size14, weight: .medium, color: .gray400, applyLineHeight: true)
    }
}
