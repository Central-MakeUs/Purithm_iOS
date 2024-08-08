//
//  FilterPremiumFilterView.swift
//  CoreUIKit
//
//  Created by 이숭인 on 8/9/24.
//

import UIKit
import SnapKit
import Then
import CoreCommonKit

final class FilterPremiumFilterView: BaseView {
    let container = UIView().then {
        $0.backgroundColor = .black040
        $0.isUserInteractionEnabled = false
    }
    
    let premiumImageView = UIImageView().then {
        $0.backgroundColor = .clear
    }
    let premiumLabel = PurithmLabel(typography: Constants.premiumLabelTypo)
    
    let stampContainer = UIView().then {
        $0.layer.cornerRadius = 28 / 2
    }
    let stampLabel = PurithmLabel(typography: Constants.stampLabelTypo)
    
    override func setup() {
        super.setup()
        
        self.backgroundColor = .clear
    }
    
    override func setupSubviews() {
        addSubview(container)
        
        [premiumImageView, premiumLabel, stampContainer].forEach {
            container.addSubview($0)
        }
        
        stampContainer.addSubview(stampLabel)
    }
    
    override func setupConstraints() {
        container.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        premiumImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.snp.centerY).offset(-4)
            make.size.equalTo(58)
        }
        
        premiumLabel.snp.makeConstraints { make in
            make.top.equalTo(self.snp.centerY).offset(4)
            make.horizontalEdges.equalToSuperview().inset(8)
        }
        
        stampContainer.snp.makeConstraints { make in
            make.top.equalTo(premiumLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        
        stampLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(4)
            make.horizontalEdges.equalToSuperview().inset(8)
        }
    }
    
    func configure(with type: PlanType) {
        switch type {
        case .free:
            break
        case .premium:
            premiumImageView.image = .grPremium
            premiumLabel.text = "Premium filter"
            stampLabel.text = "누적 스탬프 8개 +"
            stampContainer.backgroundColor = .blue400
        case .premiumPlus:
            premiumImageView.image = .grPremiumPlus
            premiumLabel.text = "Premium+ filter"
            stampLabel.text = "누적 스탬프 16개 +"
            stampContainer.backgroundColor = .purple500
        }
    }
}

extension FilterPremiumFilterView {
    private enum Constants {
        static let premiumLabelTypo = Typography(size: .size21, weight: .medium, alignment: .center, color: .white, applyLineHeight: true)
        static let stampLabelTypo = Typography(size: .size14, weight: .medium, alignment: .center, color: .white, applyLineHeight: true)
    }
}

