//
//  PurithmNavigationTitleView.swift
//  Swit-iOS
//
//  Created by Ren Shin on 2023/07/17.
//  Copyright © 2023 Swit. All rights reserved.
//

import UIKit
import SnapKit

final class PurithmNavigationTitleView: BaseView {
    private let titleLabel = UILabel()

    let type: NavigationBarType
    let title: String

    init(with type: NavigationBarType, title: String) {
        self.type = type
        self.title = title
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }

    override func setup() {
        super.setup()
        backgroundColor = .clear

        titleLabel.applyTypography(with: getTitleTypography(by: type))

        titleLabel.text = title
    }

    override func setupSubviews() {
        addSubview(titleLabel)
    }

    override func setupConstraints() {
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}

extension PurithmNavigationTitleView {
    private func getTitleTypography(by type: NavigationBarType) -> Typography {
        Typography(size: .size18, weight: .semibold, alignment: type.textAlignment, color: .gray500, applyLineHeight: false)
    }
}
