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

struct ProfileStampContainerComponent: Component {
    var identifier: String
    
    func hash(into hasher: inout Hasher) {
        
    }
}

extension ProfileStampContainerComponent {
    typealias ContentType = ProfileStampContainerView
    
    func render(content: ContentType, context: Self, cancellable: inout Set<AnyCancellable>) {
        content.configure()
    }
}

final class ProfileStampContainerView: BaseView {
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

    let descriptionLabel = PurithmLabel(typography: Constants.descriptionTypo)
    
    let stampContainer = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fillEqually
        $0.spacing = 20
    }
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
    let imageViews: [Int: UIImageView] = [
        0: UIImageView(image: .grFlowerLock),
        1: UIImageView(image: .grCloudLock),
        2: UIImageView(image: .grGlowLock),
        3: UIImageView(image: .grCloverLock),
        4: UIImageView(image: .grHeartLock),
        5: UIImageView(image: .grStarLock),
        6: UIImageView(image: .grFlower2Lock),
        7: UIImageView(image: .grPremiumLock),
    ]
    
    override func setup() {
        super.setup()
        
        self.layer.cornerRadius = 12
        self.clipsToBounds = true
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
        imageViews.keys.sorted().prefix(4).compactMap { imageViews[$0] }.forEach {
            stampTopContainer.addArrangedSubview($0)
        }
        
        stampContainer.addArrangedSubview(stampBottomContainer)
        imageViews.keys.sorted()[4...7].compactMap { imageViews[$0] }.forEach {
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
    
    func configure() {
        stampCountLabel.text = "남은 스탬프 4"
        descriptionLabel.text = "4개 더 모으면 premium+ 필터를 열람할 수 있어요"
    }
}

extension ProfileStampContainerView {
    private enum Constants {
        static let titleTypo = Typography(size: .size18, weight: .bold, color: .gray500, applyLineHeight: true)
        static let stampCountTypo = Typography(size: .size14, weight: .semibold, color: .white, applyLineHeight: true)
        static let descriptionTypo = Typography(size: .size14, weight: .medium, alignment: .center, color: .gray500, applyLineHeight: true)
    }
}
