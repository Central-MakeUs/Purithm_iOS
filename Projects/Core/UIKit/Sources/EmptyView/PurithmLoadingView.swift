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
        // 메인 번들 참조
        guard let animation = LottieAnimation.named("indicator_lottie", bundle: .main) else {
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
