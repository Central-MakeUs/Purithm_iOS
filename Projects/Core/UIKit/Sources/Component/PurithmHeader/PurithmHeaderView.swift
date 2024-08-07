//
//  PurithmHeaderView.swift
//  CoreUIKit
//
//  Created by 이숭인 on 8/6/24.
//

import UIKit
import CoreCommonKit
import Combine
import SnapKit
import Then

public final class PurithmHeaderView: BaseView {
    var cancellables = Set<AnyCancellable>()
    
    let headerContainer = UIView()
    public let backButton = UIButton()
    let detailTitleLabel = PurithmLabel(typography: Constants.titleTypo)
    
    let likeContainer = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fillProportionally
    }
    public let likeButton = UIButton().then {
        $0.setImage(.icLikeUnpressed.withTintColor(.gray300), for: .normal)
        $0.setImage(.icLikePressed.withTintColor(.blue400), for: .selected)
    }
    let likeCountLabel = PurithmLabel(typography: Constants.likeCountTypo)
    
    public override func setup() {
        super.setup()
    }
    
    public override func setupSubviews() {
        addSubview(headerContainer)
        
        [backButton, detailTitleLabel, likeContainer].forEach {
            headerContainer.addSubview($0)
        }
        
        [likeButton, likeCountLabel].forEach {
            likeContainer.addArrangedSubview($0)
        }
    }
    
    public override func setupConstraints() {
        headerContainer.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        backButton.snp.makeConstraints { make in
            make.size.equalTo(24)
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        detailTitleLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(10)
            make.leading.equalTo(backButton.snp.trailing).offset(12)
            make.trailing.equalTo(likeContainer.snp.leading).offset(-12)
        }
        
        likeButton.snp.makeConstraints { make in
            make.size.equalTo(24)
        }
        
        likeContainer.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
    public func configure(with headerType: PurithmHeaderType) {
        switch headerType {
        case .back(let title, let likeCount, let isLike):
            backButton.setImage(.icArrowLeft, for: .normal)
            detailTitleLabel.text = title
            likeButton.isSelected = isLike
            likeCountLabel.isHidden = false
            if likeCount > .zero {
                likeCountLabel.text = "\(likeCount)"
            }
        case .close(let title, let isLike):
            backButton.setImage(.icCancel, for: .normal)
            detailTitleLabel.text = title
            likeButton.isSelected = isLike
            likeCountLabel.isHidden = true
        }
    }
}

extension PurithmHeaderView {
    private enum Constants {
        static let titleTypo = Typography(size: .size32, weight: .medium, color: .gray500, applyLineHeight: true)
        static let likeCountTypo = Typography(size: .size12, weight: .medium, alignment: .center, color: .gray300, applyLineHeight: true)
    }
}
