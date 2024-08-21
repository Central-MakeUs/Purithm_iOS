//
//  ProfileSettingMenuHeaderComponent.swift
//  Profile
//
//  Created by 이숭인 on 8/19/24.
//

import UIKit
import CoreUIKit
import CoreCommonKit
import Combine

struct ProfileSettingMenuHeaderComponent: Component {
    var identifier: String
    let title: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
    }
}

extension ProfileSettingMenuHeaderComponent {
    typealias ContentType = ProfileSettingMenuHeaderView
    
    func render(content: ContentType, context: Self, cancellable: inout Set<AnyCancellable>) {
        content.configure(with: context.title)
    }
}

final class ProfileSettingMenuHeaderView: BaseView {
    let titleLabel = PurithmLabel(typography: Constants.titleTypo)
    
    override func setup() {
        super.setup()
        
        self.backgroundColor = .gray100
    }
    
    override func setupSubviews() {
        addSubview(titleLabel)
    }
    
    override func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configure(with title: String) {
        titleLabel.text = title
    }
}

extension ProfileSettingMenuHeaderView {
    private enum Constants {
        static let titleTypo = Typography(size: .size18, weight: .bold, color: .gray500, applyLineHeight: true)
    }
}
