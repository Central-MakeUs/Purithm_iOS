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
    
    let headerContainer = UIView().then {
        $0.backgroundColor = .gray100
    }
    
    let leftContainer = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.alignment = .center
        $0.spacing = 10
    }
    public let leftButton = UIButton()
    let titleLabel = PurithmLabel(typography: Constants.titleTypo).then {
        $0.text = "Header"
    }

    let rightContainer = UIStackView().then {
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
        self.backgroundColor = .gray100
    }
    
    public override func setupSubviews() {
        addSubview(headerContainer)
        headerContainer.addSubview(leftContainer)
        leftContainer.addArrangedSubview(leftButton)
        leftContainer.addArrangedSubview(titleLabel)
        
        headerContainer.addSubview(rightContainer)
        rightContainer.addArrangedSubview(likeButton)
        rightContainer.addArrangedSubview(likeCountLabel)
        
    }
    
    public override func setupConstraints() {
        headerContainer.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(48)
        }
        
        leftContainer.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.lessThanOrEqualTo(rightContainer.snp.leading).offset(-12)
        }
        
        rightContainer.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.trailing.equalToSuperview()
            make.leading.lessThanOrEqualTo(leftContainer.snp.trailing).offset(12)
        }
        
        leftButton.snp.makeConstraints { make in
            make.size.equalTo(24)
        }
    }
    
    public func configure(with headerType: PurithmHeaderType) {
        switch headerType {
        case .none(let title):
            leftButton.isHidden = true
            rightContainer.isHidden = true
            
            titleLabel.text = title
        case .back(let title, let likeCount, let isLike):
            leftButton.isHidden = false
            rightContainer.isHidden = false
            likeCountLabel.isHidden = false
            
            titleLabel.text = title
            leftButton.setImage(.icArrowLeft.withTintColor(.gray500), for: .normal)
            likeCountLabel.text = "\(likeCount)"
            likeButton.isSelected = isLike
        case .close(let title, let isLike):
            leftButton.isHidden = false
            rightContainer.isHidden = false
            likeCountLabel.isHidden = true
            
            titleLabel.text = title
            leftButton.setImage(.icCancel.withTintColor(.gray500), for: .normal)
            likeButton.isSelected = isLike
        }
    }
}

extension PurithmHeaderView {
    private enum Constants {
        static let titleTypo = Typography(size: .size32, weight: .medium, color: .gray500, applyLineHeight: true)
        static let likeCountTypo = Typography(size: .size12, weight: .medium, alignment: .center, color: .gray300, applyLineHeight: true)
    }
}
