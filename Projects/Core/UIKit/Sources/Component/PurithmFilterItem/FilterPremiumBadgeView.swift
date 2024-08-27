//
//  FilterPremiumBadgeView.swift
//  CoreUIKit
//
//  Created by 이숭인 on 8/18/24.
//

import UIKit
import SnapKit
import Then
import CoreCommonKit

final class FilterPremiumBadgeView: BaseView {
    let container = UIView().then {
        $0.layer.cornerRadius = 22 / 2
        $0.clipsToBounds = true
    }
    let label = PurithmLabel(typography: Constants.labelTypo)
    
    override func setup() {
        super.setup()
        
        backgroundColor = .clear
    }
    
    override func setupSubviews() {
        addSubview(container)
        
        container.addSubview(label)
    }
    
    override func setupConstraints() {
        container.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(24)
        }
        
        label.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(8)
        }
    }
    
    public func configure(with type: PlanType) {
        switch type {
        case .free:
            self.isHidden = true
        case .premium:
            self.isHidden = false
            label.text = "Premium"
            container.backgroundColor = .blue400
        case .premiumPlus:
            self.isHidden = false
            label.text = "Premium +"
            container.backgroundColor = .purple500
        }
    }
}

extension FilterPremiumBadgeView {
    private enum Constants {
        static let labelTypo = Typography(size: .size14, weight: .medium, color: .white, applyLineHeight: true)
    }
}
