//
//  LoginAnimateView.swift
//  CoreUIKit
//
//  Created by 이숭인 on 8/17/24.
//

import UIKit
import Then
import CoreCommonKit
import SnapKit

public final class WelcomeAnimateView: BaseView {
    let backgroundImageView = UIImageView().then {
        $0.image = .bgOnboarding5
    }
    
    let textContainer = UIView()
    let titleLabel = PurithmLabel(typography: Constants.titleTypo)
    let descriptionLabel = PurithmLabel(typography: Constants.descriptionTypo).then {
        $0.numberOfLines = 0
    }
    
    public override func setup() {
        super.setup()
        
        self.backgroundColor = .gray100
        configure()
    }
    
    public override func setupSubviews() {
        addSubview(backgroundImageView)
        addSubview(textContainer)
        
        textContainer.addSubview(titleLabel)
        textContainer.addSubview(descriptionLabel)
    }
    
    public override func setupConstraints() {
        backgroundImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(450)
        }
        
        textContainer.snp.makeConstraints { make in
            make.top.equalTo(backgroundImageView.snp.bottom).offset(50)
            make.centerX.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    private func configure() {
        titleLabel.text = "가입 완료!"
        descriptionLabel.text = "나만의 감성 사진을\n만들러 가볼까요?"
    }
}

extension WelcomeAnimateView {
    private enum Constants {
        static let titleTypo = Typography(size: .size16, weight: .medium, alignment: .center, color: .gray500, applyLineHeight: true)
        static let descriptionTypo = Typography(size: .size24, weight: .bold, alignment: .center, color: .gray500, applyLineHeight: true)
    }
}
