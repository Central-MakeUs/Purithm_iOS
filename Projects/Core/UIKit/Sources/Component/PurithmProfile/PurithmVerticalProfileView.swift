//
//  PurithmVerticalProfileModel.swift
//  CoreUIKit
//
//  Created by 이숭인 on 8/9/24.
//

import UIKit
import CoreCommonKit
import Then
import SnapKit
import Kingfisher

public struct PurithmVerticalProfileModel {
    let type: PurithmProfileType
    let name: String
    let profileURLString: String
    let introduction: String
    
    public init(type: PurithmProfileType, name: String, profileURLString: String, introduction: String) {
        self.type = type
        self.name = name
        self.profileURLString = profileURLString
        self.introduction = introduction
    }
}

public final class PurithmVerticalProfileView: BaseView {
    let container = UIView()
    let backgroundImageView = UIImageView().then {
        $0.image = .bgMd
    }
    
    let profileView = UIImageView()
    let textContainer = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fillProportionally
        $0.alignment = .center
    }
    
    let nameLabel = PurithmLabel(typography: Constants.nameTypo)
    let introductionLabel = PurithmLabel(typography: Constants.introductionTypo)
    let editProfileLabel = PurithmLabel(typography: Constants.editProfileTypo).then {
        $0.text = "Edit profile"
    }
    
    public override func setupSubviews() {
        addSubview(container)
        addSubview(backgroundImageView)
        
        [profileView, textContainer].forEach {
            container.addSubview($0)
        }
        
        textContainer.addArrangedSubview(nameLabel)
        textContainer.addArrangedSubview(introductionLabel)
        textContainer.addArrangedSubview(editProfileLabel)
    }
    
    public override func setupConstraints() {
        container.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        profileView.snp.makeConstraints { make in
            make.size.equalTo(100)
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.horizontalEdges.lessThanOrEqualToSuperview().inset(20)
        }
        
        textContainer.snp.makeConstraints { make in
            make.top.equalTo(profileView.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    func configure(with profileModel: PurithmVerticalProfileModel) {
        switch profileModel.type {
        case .artist:
            introductionLabel.isHidden = false
            introductionLabel.text = profileModel.introduction
        case .user:
            introductionLabel.isHidden = true
        }
        
        nameLabel.text = profileModel.name
        
        if let url = URL(string: profileModel.profileURLString) {
            profileView.kf.setImage(with: url)
        }
    }
}

extension PurithmVerticalProfileView {
    private enum Constants {
        static let nameTypo = Typography(size: .size30, weight: .semibold, color: .gray500, applyLineHeight: true)
        static let introductionTypo = Typography(size: .size16, weight: .medium, color: .gray500, applyLineHeight: true)
        static let editProfileTypo = Typography(size: .size14, weight: .semibold, color: .blue400, applyLineHeight: true)
    }
}
