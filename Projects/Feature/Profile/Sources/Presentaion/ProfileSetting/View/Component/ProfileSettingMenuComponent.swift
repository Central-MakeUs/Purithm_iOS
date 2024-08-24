//
//  ProfileSettingMenuComponent.swift
//  Profile
//
//  Created by 이숭인 on 8/19/24.
//

import UIKit
import CoreUIKit
import CoreCommonKit
import Combine

struct ProfileSettingMenuComponentModel {
    let identifier: String
    let menu: ProfileSettingMenu
}

struct ProfileSettingMenuComponent: Component {
    var identifier: String
    var menu: ProfileSettingMenu
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(menu)
    }
}

extension ProfileSettingMenuComponent {
    typealias ContentType = ProfileSettingMenuView
    
    func render(content: ContentType, context: Self, cancellable: inout Set<AnyCancellable>) {
        content.configure(with: context.menu)
    }
}

final class ProfileSettingMenuView: BaseView {
    let menuLabel = PurithmLabel(typography: Constants.menuTypo)
    
    let rightContainer = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillProportionally
        $0.alignment = .center
    }
    let rightImageView = UIImageView().then {
        $0.image = .icArrowRight.withTintColor(.gray300)
    }
    let rightLabel = PurithmLabel(typography: Constants.rightLabelTypo)
    
    override func setup() {
        super.setup()
        
        self.backgroundColor = .gray100
    }
    
    override func setupSubviews() {
        addSubview(menuLabel)
        addSubview(rightContainer)
        
        rightContainer.addArrangedSubview(rightImageView)
        rightContainer.addArrangedSubview(rightLabel)
    }
    
    override func setupConstraints() {
        menuLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalTo(rightContainer.snp.leading).offset(-8)
        }
        
        rightContainer.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        rightImageView.snp.makeConstraints { make in
            make.size.equalTo(20)
        }
    }
    
    func configure(with menu: ProfileSettingMenu){
        menuLabel.text = menu.title
        
        switch menu {
        case .termsOfService, .privacyPolicy, .accountInfo, .editProfile:
            rightContainer.isHidden = false
            rightImageView.isHidden = false
            rightLabel.isHidden = true
        case .versionInfo:
            rightContainer.isHidden = false
            rightImageView.isHidden = true
            rightLabel.isHidden = false
            rightLabel.text = "1.0" //TODO: 버전정보 넣어야함
        default:
            rightContainer.isHidden = true
            rightImageView.isHidden = true
            rightLabel.isHidden = true
        }
    }
}

extension ProfileSettingMenuView {
    private enum Constants {
        static let menuTypo = Typography(size: .size16, weight: .medium, color: .gray500, applyLineHeight: true)
        static let rightLabelTypo = Typography(size: .size16, weight: .medium, color: .gray300, applyLineHeight: true)
    }
}
