//
//  LoginView.swift
//  Login
//
//  Created by 이숭인 on 7/23/24.
//

import UIKit
import CoreUIKit
import SnapKit
import Then
import CoreCommonKit

extension LoginView {
    enum Constants {
        static let logoTypo = Typography(size: .size17, weight: .semibold, color: .blue400)
    }
}

public final class LoginView: BaseView {
    let backgroundImage = UIImageView().then {
        $0.image = .bgLg
        $0.contentMode = .scaleAspectFill
    }
    
    let logoImage = UIImageView().then {
        $0.image = .logoType3D
        $0.contentMode = .scaleAspectFit
    }
    
    let logoLabel = PurithmLabel(typography: Constants.logoTypo).then {
        $0.text = "감성사진을 위한 필터 커머스, 퓨리즘"
    }
    
    let appleLoginButton = UIButton().then {
        $0.setBackgroundImage(.appleLoginButton, for: .normal)
        $0.imageView?.contentMode = .scaleAspectFill
    }
    
    let kakaoLoginButton = UIButton().then {
        $0.setBackgroundImage(.kakaoLoginButton, for: .normal)
        $0.imageView?.contentMode = .scaleAspectFill
    }
    
    
    public override func setupSubviews() {
        [backgroundImage, logoImage, logoLabel, appleLoginButton, kakaoLoginButton].forEach {
            addSubview($0)
        }
    }
    
    public override func setupConstraints() {
        backgroundImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        logoImage.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(256)
            make.horizontalEdges.equalToSuperview().inset(32)
            make.height.equalTo(112)
        }
        
        logoLabel.snp.makeConstraints { make in
            make.top.equalTo(logoImage.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
        }
        
        kakaoLoginButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(49)
            make.bottom.equalTo(appleLoginButton.snp.top).offset(-16)
        }

        appleLoginButton.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide).inset(32)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(49)
        }
    }
}
