//
//  PurithmPagerBadgeView.swift
//  CoreUIKit
//
//  Created by 이숭인 on 8/8/24.
//

import UIKit
import CoreCommonKit
import SnapKit
import Then

public final class PurithmPagerBadgeView: BaseView {
    let badgeLabel = PurithmLabel(typography: Constants.badgeTypo)
    
    public override func setup() {
        super.setup()
        
        self.layer.cornerRadius = 24 / 2
        self.backgroundColor = .blue400
    }
    
    public override func setupSubviews() {
        addSubview(badgeLabel)
    }
    
    public override func setupConstraints() {
        self.snp.makeConstraints { make in
            make.height.equalTo(24)
        }
        
        badgeLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(8)
        }
    }
    
    public func configure(total: Int, current: Int) {
        badgeLabel.text = "\(current + 1) / \(total)"
    }
}

extension PurithmPagerBadgeView {
    private enum Constants {
        static let badgeTypo = Typography(size: .size14, weight: .medium, color: .white, applyLineHeight: true)
    }
}
