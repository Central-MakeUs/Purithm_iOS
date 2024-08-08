//
//  PremiumFilterRockBottomSheetContentView.swift
//  CoreUIKit
//
//  Created by 이숭인 on 8/7/24.
//

import UIKit
import CoreCommonKit
import SnapKit
import Then

final class PremiumFilterRockBottomSheetContentView: BaseView {
    let container = UIView().then {
        $0.backgroundColor = .white
    }
    
    let premiumFilterContentImageView = UIImageView().then {
        $0.image = .premiumFilterRockContent
        $0.contentMode = .scaleAspectFill
    }
    let premiumPlusFilterContentImageView = UIImageView().then {
        $0.image = .premiumPlusFilterRockContent
        $0.contentMode = .scaleAspectFill
    }

    override func setupSubviews() {
        addSubview(container)
        
        [premiumFilterContentImageView, premiumPlusFilterContentImageView].forEach {
            container.addSubview($0)
        }
    }
    
    override func setupConstraints() {
        container.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        premiumFilterContentImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(58)
        }
        
        premiumPlusFilterContentImageView.snp.makeConstraints { make in
            make.top.equalTo(premiumFilterContentImageView.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(58)
        }
    }
}
