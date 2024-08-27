//
//  SatisfactionBottomSheetContentView.swift
//  CoreUIKit
//
//  Created by 이숭인 on 8/7/24.
//

import UIKit
import CoreCommonKit
import SnapKit
import Then

final class SatisfactionBottomSheetContentView: BaseView {
    let container = UIView().then {
        $0.backgroundColor = .white
    }
    
    let satisfactionImageView = UIImageView().then {
        $0.image = .satisfactionIntensity
        $0.contentMode = .scaleAspectFill
    }
    
    override func setupSubviews() {
        addSubview(container)
        container.addSubview(satisfactionImageView)
    }
    
    override func setupConstraints() {
        container.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(12)
            make.verticalEdges.equalToSuperview().inset(20)
        }
        
        satisfactionImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(70)
        }
    }
}
