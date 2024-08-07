//
//  FilterDetailBottomView.swift
//  Filter
//
//  Created by 이숭인 on 7/31/24.
//

import UIKit
import CoreUIKit
import CoreCommonKit
import Combine

final class FilterDetailBottomView: BaseView {
    //MARK: UI
    let gradientContainer = UIView()
    
    let originalImageButton = PlainButton(type: .transparent, variant: .option, size: .medium).then {
        $0.text = "원본"
        $0.image = .icFilterOff.withTintColor(.white)
        $0.shape = .circle
        $0.hasShadow = true
        $0.hasContentShdaow = true
    }
    
    let textHideButton = PlainButton(type: .transparent, variant: .option, size: .medium).then {
        $0.text = "텍스트"
        $0.image = .icEyeOff.withTintColor(.white)
        $0.shape = .circle
        $0.hasShadow = true
        $0.hasContentShdaow = true
    }
    
    let conformButton = PlainButton(type: .transparent, variant: .default, size: .large).then {
        $0.text = "필터값 보기"
    }
    
    let bottomGradientView = PurithmGradientView().then {
        $0.colorType = .purple(direction: .top)
    }
    
    //MARK: Life Cycle
    override func setup() {
        super.setup()
        
        self.backgroundColor = .clear
    }
    
    override func setupSubviews() {
        addSubview(gradientContainer)
        
        [originalImageButton, textHideButton, conformButton, bottomGradientView].forEach {
            gradientContainer.addSubview($0)
        }
        
        gradientContainer.sendSubviewToBack(bottomGradientView)
    }
    
    override func setupConstraints() {
        gradientContainer.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        bottomGradientView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        originalImageButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.trailing.equalToSuperview().inset(20)
            make.leading.greaterThanOrEqualToSuperview().inset(20)
            make.bottom.equalTo(textHideButton.snp.top).offset(-20)
        }
        
        textHideButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.leading.greaterThanOrEqualToSuperview().inset(20)
            make.bottom.equalTo(conformButton.snp.top).offset(-20)
        }
        
        conformButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
    
    func fadeOutAndHide(with duration: TimeInterval) {
        UIView.animate(withDuration: duration) {
            self.conformButton.alpha = 0
            self.bottomGradientView.hide()
        }
    }
    
    func fadeInAndShow(with duration: TimeInterval) {
        UIView.animate(withDuration: duration) {
            self.conformButton.alpha = 1
            self.bottomGradientView.show()
        }
    }
}

