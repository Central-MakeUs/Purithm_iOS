//
//  OnboardingView.swift
//  Login
//
//  Created by 이숭인 on 7/24/24.
//

import UIKit
import CoreUIKit
import CoreCommonKit

extension OnboardingView {
    enum Constants {
        static let titleTypo = Typography(size: .size24, weight: .semibold, alignment: .center, color: .gray500, applyLineHeight: true)
        static let subTitleTypo = Typography(size: .size16, weight: .medium, alignment: .center, color: .gray500, applyLineHeight: true)
    }
}

final class OnboardingView: BaseView {
    let backgroundImageView = UIImageView().then {
        $0.image = .bgOnboarding1
    }
    
    let titleLabel = PurithmLabel(typography: Constants.titleTypo).then {
        $0.numberOfLines = 1
    }
    let subTitleLabel = PurithmLabel(typography: Constants.subTitleTypo).then {
        $0.numberOfLines = 0
    }
    
    override func setupSubviews() {
        self.backgroundColor = .gray100
        
        [backgroundImageView, titleLabel, subTitleLabel].forEach {
            addSubview($0)
        }
    }
    
    override func setupConstraints() {
        backgroundImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(450)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(backgroundImageView.snp.bottom).offset(56)
            make.centerX.equalToSuperview()
            make.horizontalEdges.lessThanOrEqualTo(safeAreaLayoutGuide).inset(16)
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.horizontalEdges.greaterThanOrEqualTo(safeAreaLayoutGuide).inset(16)
        }
    }
    
    func configure(image: UIImage, title: String, subTitle: String) {
        self.backgroundImageView.image = image
        self.titleLabel.text = title
        self.subTitleLabel.text = subTitle
    }
}
