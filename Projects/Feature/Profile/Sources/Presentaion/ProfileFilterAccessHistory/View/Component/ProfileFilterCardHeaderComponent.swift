//
//  ProfileFilterCardHeaderComponent.swift
//  Profile
//
//  Created by 이숭인 on 8/23/24.
//

import UIKit
import CoreUIKit
import CoreCommonKit
import Combine

struct ProfileFilterCardHeaderComponent: Component {
    var identifier: String
    let date: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(date)
    }
}

extension ProfileFilterCardHeaderComponent {
    typealias ContentType = ProfileFilterCardHeaderView
    
    func render(content: ContentType, context: Self, cancellable: inout Set<AnyCancellable>) {
        content.configure(date: context.date)
    }
}

final class ProfileFilterCardHeaderView: BaseView {
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
    
    func configure(date: String) {
        titleLabel.text = date
    }
}

extension ProfileFilterCardHeaderView {
    private enum Constants {
        static let titleTypo = Typography(size: .size14, weight: .medium, color: .gray400, applyLineHeight: true)
    }
}
