//
//  ProfileAccountItemComponent.swift
//  Profile
//
//  Created by 이숭인 on 8/22/24.
//

import UIKit
import CoreUIKit
import CoreCommonKit
import Combine

struct ProfileAccountItemComponent: Component {
    var identifier: String
    let infomationType: ProfileAccountInfomationType
    let infomation: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(infomationType)
        hasher.combine(infomation)
    }
}

extension ProfileAccountItemComponent {
    typealias ContentType = ProfileAccountItemView
    
    func render(content: ContentType, context: Self, cancellable: inout Set<AnyCancellable>) {
        content.configure(with: context.infomationType, infomation: context.infomation)
    }
}

final class ProfileAccountItemView: BaseView {
    let titleLabel = PurithmLabel(typography: Constants.titleTypo)
    
    let rightContainer = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.alignment = .center
        $0.spacing = 10
    }
    let infomationLabel = PurithmLabel(typography: Constants.infomationTypo).then {
        $0.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
    }
    let signUpLogoImageView = UIImageView().then {
        $0.backgroundColor = .gray200
        $0.layer.cornerRadius = 4
        $0.clipsToBounds = true
    }
    
    override func setup() {
        super.setup()
        
        self.backgroundColor = .gray100
    }
    
    override func setupSubviews() {
        addSubview(titleLabel)
        addSubview(rightContainer)
        
        rightContainer.addArrangedSubview(infomationLabel)
        rightContainer.addArrangedSubview(signUpLogoImageView)
    }
    
    override func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
            make.trailing.equalTo(rightContainer.snp.leading).offset(-10)
        }
        
        rightContainer.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.trailing.equalToSuperview()
            make.leading.equalTo(titleLabel.snp.trailing).offset(10)
        }
        
        signUpLogoImageView.snp.makeConstraints { make in
            make.size.equalTo(24)
        }
    }
    
    func configure(with type: ProfileAccountInfomationType, infomation: String) {
        titleLabel.text = type.title
        infomationLabel.text = infomation
        
        signUpLogoImageView.isHidden = !(type == .signUpMethod)
        let signupMethodType = ProfileAccountInfomationModel.Method(rawValue: infomation) ?? .kakao
        signUpLogoImageView.image  = signupMethodType.logoImage
    }
}

extension ProfileAccountItemView {
    private enum Constants {
        static let titleTypo = Typography(size: .size16, weight: .semibold, color: .gray500, applyLineHeight: true)
        static let infomationTypo = Typography(size: .size16, weight: .medium, color: .gray400, applyLineHeight: true)
    }
}
