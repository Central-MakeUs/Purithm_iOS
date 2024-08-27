//
//  ProfileMenuComponent.swift
//  Profile
//
//  Created by 이숭인 on 8/21/24.
//

import Foundation

import UIKit
import CoreUIKit
import CoreCommonKit
import Combine

struct ProfileMenuSelectAction: ActionEventItem {
    let identifier: String
}

struct ProfileMenuComponent: Component {
    var identifier: String
    let menu: ProfileMenu
    let count: Int
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(menu)
        hasher.combine(count)
    }
}

extension ProfileMenuComponent {
    typealias ContentType = ProfileMenuView
    
    func render(content: ContentType, context: Self, cancellable: inout Set<AnyCancellable>) {
        content.configure(menu: context.menu, count: context.count)
        
        content.menuSelectTapGesture.tapPublisher
            .sink { [weak content] _ in
                content?.actionEventEmitter.send(ProfileMenuSelectAction(identifier: context.identifier))
            }
            .store(in: &cancellable)
    }
}

final class ProfileMenuView: BaseView, ActionEventEmitable {
    var actionEventEmitter = PassthroughSubject<ActionEventItem, Never>()
    
    let leftImageView = UIImageView()
    let menuTitleLabel = PurithmLabel(typography: Constants.titleTypo).then {
        $0.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    }
    
    let rightContainer = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillProportionally
        $0.alignment = .center
        $0.spacing = 10
        $0.isUserInteractionEnabled = true
    }
    let countLabel = PurithmLabel(typography: Constants.countTypo).then {
        $0.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
    }
    let rightImageView = UIImageView().then {
        $0.image = .icArrowRight.withTintColor(.gray300)
    }
    
    let menuSelectTapGesture = UITapGestureRecognizer()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        countLabel.snp.remakeConstraints { make in
            make.width.equalTo(countLabel.intrinsicContentSize.width)
        }
    }
    
    override func setup() {
        super.setup()
        
        self.backgroundColor = .gray100
        rightContainer.addGestureRecognizer(menuSelectTapGesture)
    }
    
    override func setupSubviews() {
        addSubview(leftImageView)
        addSubview(menuTitleLabel)
        addSubview(rightContainer)
        
        rightContainer.addArrangedSubview(countLabel)
        rightContainer.addArrangedSubview(rightImageView)
    }
    
    override func setupConstraints() {
        leftImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
            make.size.equalTo(18)
        }
        
        menuTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(leftImageView.snp.trailing).offset(10)
            make.centerY.equalToSuperview()
        }
        
        rightContainer.snp.makeConstraints { make in
            make.leading.equalTo(menuTitleLabel.snp.trailing).offset(10)
            make.trailing.equalToSuperview()
            make.verticalEdges.equalToSuperview()
        }
        
        rightImageView.snp.makeConstraints { make in
            make.size.equalTo(20)
        }
    }
    
    func configure(menu: ProfileMenu, count: Int) {
        leftImageView.image = menu.leftImage
        menuTitleLabel.text = menu.title
        
        countLabel.text = "\(count)"
    }
}

extension ProfileMenuView {
    private enum Constants {
        static let titleTypo = Typography(size: .size16, weight: .semibold, color: .gray500, applyLineHeight: true)
        static let countTypo = Typography(size: .size16, weight: .semibold, color: .gray300, applyLineHeight: true)
    }
}
