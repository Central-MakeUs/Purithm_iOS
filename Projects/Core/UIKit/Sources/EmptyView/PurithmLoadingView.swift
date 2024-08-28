//
//  PurithmLoadingView.swift
//  CoreUIKit
//
//  Created by 이숭인 on 8/28/24.
//

import UIKit
import CoreCommonKit
import SnapKit

public final class PurithmLoadingView: BaseView {
    let container = UIView()
    
    let activityIndicator = UIActivityIndicatorView(style: .medium).then {
        $0.color = .blue400
    }
    
    public override func setup() {
        super.setup()
        
        self.backgroundColor = .gray100
    }
    
    public override func setupSubviews() {
        addSubview(activityIndicator)
        
    }
    
    public override func setupConstraints() {
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(60)
        }
    }
    
    public func showActivityIndicatorIfNeeded(with isShow: Bool) {
        isShow ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
    }
}
