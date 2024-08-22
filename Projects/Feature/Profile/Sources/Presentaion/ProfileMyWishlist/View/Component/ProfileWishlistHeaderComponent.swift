//
//  ProfileWishlistHeaderComponent.swift
//  Profile
//
//  Created by 이숭인 on 8/22/24.
//

import UIKit
import CoreUIKit
import CoreCommonKit
import Combine

struct ProfileWishlistHeaderComponent: Component {
    var identifier: String
    let count: Int
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(count)
    }
}

extension ProfileWishlistHeaderComponent {
    typealias ContentType = ProfileFeedHeaderView
    
    func render(content: ContentType, context: Self, cancellable: inout Set<AnyCancellable>) {
        content.configure(count: context.count)
    }
}

final class ProfileWishlistHeader: BaseView {
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
            make.horizontalEdges.equalToSuperview()
            make.verticalEdges.equalToSuperview().inset(20)
        }
    }
    
    func configure(count: Int) {
        titleLabel.text = "총 \(count)개"
    }
}

extension ProfileWishlistHeader {
    private enum Constants {
        static let titleTypo = Typography(size: .size16, weight: .semibold, color: .gray500, applyLineHeight: true)
    }
}
