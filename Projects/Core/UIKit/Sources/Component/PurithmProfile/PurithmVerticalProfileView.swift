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
    public let identifier: String
    public let type: PurithmProfileType
    public let name: String
    public let profileURLString: String
    public let introduction: String
    
    public init(identifier: String, type: PurithmProfileType, name: String, profileURLString: String, introduction: String) {
        self.identifier = identifier
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
    
    let profileView = UIImageView().then {
        $0.layer.cornerRadius = 100 / 2
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFill
    }
    let textContainer = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fillProportionally
        $0.alignment = .center
    }
    
    let nameLabel = PurithmLabel(typography: Constants.nameTypo)
    let introductionLabel = PurithmLabel(typography: Constants.introductionTypo)
    let editProfileLabel = PurithmLabel(typography: Constants.editProfileTypo).then {
        $0.text = "Edit profile"
        $0.isUserInteractionEnabled = true
    }
    public let editTapGesture = UITapGestureRecognizer()
    
    public override func setup() {
        super.setup()
        
        editProfileLabel.addGestureRecognizer(editTapGesture)
    }
    
    public override func setupSubviews() {
        addSubview(backgroundImageView)
        addSubview(container)
        
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
            make.top.equalToSuperview().inset(40)
            make.centerX.equalToSuperview()
        }
        
        textContainer.snp.makeConstraints { make in
            make.top.equalTo(profileView.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.lessThanOrEqualToSuperview()
        }
    }
    
    public func configure(with profileModel: PurithmVerticalProfileModel) {
        switch profileModel.type {
        case .artist:
            introductionLabel.isHidden = false
            editProfileLabel.isHidden = true
            introductionLabel.text = profileModel.introduction
        case .user:
            introductionLabel.isHidden = true
            editProfileLabel.isHidden = false
        }
        
        nameLabel.text = profileModel.name
        
        if let url = URL(string: profileModel.profileURLString) {
            profileView.kf.setImage(with: url)
        }
        
        //이름과 프로필이 빈 경우
        if profileModel.name.isEmpty {
            nameLabel.text = "귀여운 둥지"
        }
        if profileModel.profileURLString.isEmpty {
            profileView.image = .emptyProfile
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
