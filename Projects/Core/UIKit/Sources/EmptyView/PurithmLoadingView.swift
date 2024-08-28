//
//  PurithmLoadingView.swift
//  CoreUIKit
//
//  Created by 이숭인 on 8/28/24.
//

import UIKit
import CoreCommonKit
import SnapKit
import Lottie

public final class PurithmLoadingView: BaseView {
    let container = UIView()
    
    let animationView: LottieAnimationView? = {
        // 다른 번들 참조
        let bundleIdentifier = "com.purithm.UIKit.core"
        guard let coreBundle = Bundle(identifier: bundleIdentifier) else {
            return nil
        }
        
        // 번들에서 Lottie 애니메이션 로드
        guard let animation = LottieAnimation.named("indicator_lottie", bundle: coreBundle) else {
            return nil
        }
        
        let view = LottieAnimationView(animation: animation)
        view.contentMode = .scaleAspectFit
        view.loopMode = .loop
        return view
    }()
    
    public override func setup() {
        super.setup()
        
        self.backgroundColor = .gray100
    }
    
    public override func setupSubviews() {
        guard let animationView else { return }
        addSubview(animationView)
    }
    
    public override func setupConstraints() {
        animationView?.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(30)
        }
    }
    
    public func showActivityIndicatorIfNeeded(with isShow: Bool) {
        isShow ? animationView?.play() : animationView?.pause()
    }
}
