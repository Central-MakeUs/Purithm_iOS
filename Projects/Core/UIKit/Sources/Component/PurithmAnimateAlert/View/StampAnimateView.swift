//
//  StampAnimateView.swift
//  CoreUIKit
//
//  Created by 이숭인 on 8/11/24.
//

import UIKit
import Then
import CoreCommonKit
import SnapKit

public final class StampAnimateView: BaseView {
    let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterialDark))
    
    let container = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fillProportionally
        $0.alignment = .center
        $0.spacing = 20
    }
    
    let stampImageView = UIImageView().then {
        $0.image = .grFlower
    }
    
    let titleLabel = PurithmLabel(typography: Constants.titleTypo).then {
        $0.text = "스탬프 적립 완료!"
    }
    let descriptionLabel = PurithmLabel(typography: Constants.descriptionTypo).then {
        $0.text = "꾸준히 모으면 프리미엄 필터를 열람할 수 있어요"
        $0.numberOfLines = 0
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        blurEffectView.frame = self.frame
    }
    
    public override func setup() {
        super.setup()
        
        self.backgroundColor = .clear
        blurEffectView.backgroundColor = .black040
        blurEffectView.alpha = 0.96
    }
    
    public override func setupSubviews() {
        addSubview(blurEffectView)
        addSubview(container)
        
        container.addArrangedSubview(stampImageView)
        container.addArrangedSubview(titleLabel)
        container.addArrangedSubview(descriptionLabel)
    }
    
    public override func setupConstraints() {
        container.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }
        
        stampImageView.snp.makeConstraints { make in
            make.size.equalTo(150)
        }
    }
}

extension StampAnimateView {
    private enum Constants {
        static let titleTypo = Typography(size: .size24, weight: .bold, color: .white, applyLineHeight: true)
        static let descriptionTypo = Typography(size: .size16, weight: .medium, color: .white, applyLineHeight: true)
    }
}
