//
//  ProfileStampContainerComponent.swift
//  Profile
//
//  Created by 이숭인 on 8/21/24.
//

import Foundation

import UIKit
import CoreUIKit
import CoreCommonKit
import Combine

enum Stamp: Int {
    case flower = 0
    case cloud = 1
    case glow = 2
    case clover = 3
    case heart = 4
    case star = 5
    case flower2 = 6
    case premium = 7
    
    var lockImage: UIImage {
        switch self {
        case .flower:
            return .grFlowerLock
        case .cloud:
            return .grCloudLock
        case .glow:
            return .grGlowLock
        case .clover:
            return .grCloverLock
        case .heart:
            return .grHeartLock
        case .star:
            return .grStarLock
        case .flower2:
            return .grFlower2Lock
        case .premium:
            return .grPremiumLock
        }
    }
    
    var unlockImage: UIImage {
        switch self {
        case .flower:
            return .grFlower
        case .cloud:
            return .grCloud
        case .glow:
            return .grGlow
        case .clover:
            return .grClover
        case .heart:
            return .grHeart
        case .star:
            return .grStar
        case .flower2:
            return .grFlower2
        case .premium:
            return .grPremium
        }
    }
}

struct ProfileTotalStampMoveAction: ActionEventItem { }
struct ProfileStampTapAction: ActionEventItem { }

struct ProfileStampContainerComponent: Component {
    var identifier: String
    let stampCount: Int
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(stampCount)
    }
}

extension ProfileStampContainerComponent {
    typealias ContentType = ProfileStampContainerView
    
    func render(content: ContentType, context: Self, cancellable: inout Set<AnyCancellable>) {
        content.configure(stampCount: context.stampCount)
        
        content.totalStampTapGesture.tapPublisher
            .sink { [weak content] _ in
                content?.actionEventEmitter.send(ProfileTotalStampMoveAction())
            }
            .store(in: &cancellable)
        
        content.stampContainerTapGesture.tapPublisher
            .sink { [weak content] _ in
                content?.actionEventEmitter.send(ProfileStampTapAction())
            }
            .store(in: &cancellable)
    }
}

final class ProfileStampContainerView: BaseView, ActionEventEmitable {
    var actionEventEmitter = PassthroughSubject<ActionEventItem, Never>()
    
    let container = UIView().then {
        $0.backgroundColor = .white
    }
    
    let topContainer = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.alignment = .center
    }
    let titleLabel = PurithmLabel(typography: Constants.titleTypo).then {
        $0.text = "스탬프"
    }
    
    let totalStampContainer = UIView().then {
        $0.layer.cornerRadius = 32 / 2
        $0.backgroundColor = .blue300
    }
    let stampCountLabel = PurithmLabel(typography: Constants.stampCountTypo).then {
        $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
    let rightArrowImageView = UIImageView().then {
        $0.image = .icMove.withTintColor(.white)
    }
    let totalStampTapGesture = UITapGestureRecognizer()

    let descriptionLabel = PurithmLabel(typography: Constants.descriptionTypo)
    
    let stampContainer = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fillEqually
        $0.spacing = 20
    }
    let stampContainerTapGesture = UITapGestureRecognizer()
    
    let stampTopContainer = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .equalSpacing
        $0.alignment = .fill
    }
    let stampBottomContainer = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .equalSpacing
        $0.alignment = .fill
    }
    let imageViews: [Stamp: UIImageView] = [
        .flower: UIImageView(image: Stamp.flower.lockImage),
        .cloud: UIImageView(image: Stamp.cloud.lockImage),
        .glow: UIImageView(image: Stamp.glow.lockImage),
        .clover: UIImageView(image: Stamp.clover.lockImage),
        .heart: UIImageView(image: Stamp.heart.lockImage),
        .star: UIImageView(image: Stamp.star.lockImage),
        .flower2: UIImageView(image: Stamp.flower2.lockImage),
        .premium: UIImageView(image: Stamp.premium.lockImage),
    ]
    
    override func setup() {
        super.setup()
        
        self.layer.cornerRadius = 12
        self.clipsToBounds = true
        
        totalStampContainer.addGestureRecognizer(totalStampTapGesture)
        stampContainer.addGestureRecognizer(stampContainerTapGesture)
    }
    
    override func setupSubviews() {
        addSubview(container)
        
        container.addSubview(topContainer)
        topContainer.addArrangedSubview(titleLabel)
        topContainer.addArrangedSubview(totalStampContainer)
        totalStampContainer.addSubview(stampCountLabel)
        totalStampContainer.addSubview(rightArrowImageView)
        
        container.addSubview(descriptionLabel)
        
        container.addSubview(stampContainer)
        stampContainer.addArrangedSubview(stampTopContainer)
        
        [Stamp.flower, Stamp.cloud, Stamp.glow, Stamp.clover].compactMap { imageViews[$0] }.forEach {
            stampTopContainer.addArrangedSubview($0)
        }
        
        stampContainer.addArrangedSubview(stampBottomContainer)
        [Stamp.heart, Stamp.star, Stamp.flower2, Stamp.premium].compactMap { imageViews[$0] }.forEach {
            stampBottomContainer.addArrangedSubview($0)
        }
    }
    
    override func setupConstraints() {
        container.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(20)
        }
        
        topContainer.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(32)
        }
        
        setupConstraintsByTopContainer()
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(topContainer.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(stampContainer.snp.top).offset(-20)
        }
        
        stampContainer.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview().inset(20)
        }
        
        stampTopContainer.snp.makeConstraints { make in
            make.height.equalTo(58)
        }
        
        stampBottomContainer.snp.makeConstraints { make in
            make.height.equalTo(58)
        }
    }
    
    private func setupConstraintsByTopContainer() {
        totalStampContainer.snp.makeConstraints { make in
            make.height.equalTo(32)
        }
        
        stampCountLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(8)
            make.leading.equalToSuperview().inset(12)
            make.trailing.equalTo(rightArrowImageView.snp.leading).offset(-6)
        }
        
        rightArrowImageView.snp.makeConstraints { make in
            make.size.equalTo(16)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(12)
        }
    }
    
    func configure(stampCount: Int) {
        stampCountLabel.text = "남은 스탬프 \(8 - stampCount)"
        unlockStamps(stampCount: stampCount)
        
        switch stampCount {
        case 0...7:
            descriptionLabel.text = "\(8-stampCount)개 더 모으면 premium 필터를 열람할 수 있어요"
        case 8...15:
            descriptionLabel.text = "\(16-stampCount)개 더 모으면 premium+ 필터를 열람할 수 있어요"
        default:
            descriptionLabel.text = "모든 스탬프를 모두 모았어요!"
        }
    }
    
    private func unlockStamps(stampCount: Int) {
        guard stampCount > 0 else { return }
        
        (0..<stampCount)
            .compactMap { Stamp(rawValue: $0) }.forEach {
                imageViews[$0]?.image = $0.unlockImage
            }
    }
}

extension ProfileStampContainerView {
    private enum Constants {
        static let titleTypo = Typography(size: .size18, weight: .bold, color: .gray500, applyLineHeight: true)
        static let stampCountTypo = Typography(size: .size14, weight: .semibold, color: .white, applyLineHeight: true)
        static let descriptionTypo = Typography(size: .size14, weight: .medium, alignment: .left, color: .gray500, applyLineHeight: true)
    }
}
