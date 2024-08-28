//
//  ProfileFilterCardCountHeaderComponent.swift
//  Profile
//
//  Created by 이숭인 on 8/23/24.
//

import UIKit
import CoreUIKit
import CoreCommonKit
import Combine

struct ProfileFilterCardCountHeaderComponent: Component {
    var identifier: String
    let count: Int
    let showDescription: Bool
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(count)
        hasher.combine(showDescription)
    }
}

extension ProfileFilterCardCountHeaderComponent {
    typealias ContentType = ProfileFilterCardCountHeaderView
    
    func render(content: ContentType, context: Self, cancellable: inout Set<AnyCancellable>) {
        content.configure(
            count: context.count,
            showDescription: context.showDescription
        )
    }
}

final class ProfileFilterCardCountHeaderView: BaseView {
    let titleLabel = PurithmLabel(typography: Constants.titleTypo)
    let descriptionLabel = PurithmLabel(typography: Constants.descriptionTypo)
    
    override func setup() {
        super.setup()
        
        self.backgroundColor = .gray100
    }
    
    override func setupSubviews() {
        addSubview(titleLabel)
        addSubview(descriptionLabel)
    }
    
    override func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.verticalEdges.equalToSuperview().inset(20)
            make.trailing.equalTo(descriptionLabel.snp.leading).offset(-8)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.trailing).offset(8)
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.trailing.equalToSuperview()
        }
    }
    
    func configure(count: Int, showDescription: Bool) {
        titleLabel.text = "총 \(count)개"
        
        descriptionLabel.isHidden = !showDescription
        switch count {
        case 0...3:
            descriptionLabel.text = "premium 까지 \(4 - count)개 남음"
        case 4...7:
            descriptionLabel.text = "premium+ 까지 \(8 - count)개 남음"
        default:
            descriptionLabel.text = "premium 시리즈를 모두 열람할 수 있어요!"
        }
    }
}

extension ProfileFilterCardCountHeaderView {
    private enum Constants {
        static let titleTypo = Typography(size: .size16, weight: .semibold, color: .gray500, applyLineHeight: true)
        static let descriptionTypo = Typography(size: .size14, weight: .medium, color: .gray300, applyLineHeight: true)
    }
}
