//
//  FilterEmptyView.swift
//  CoreUIKit
//
//  Created by 이숭인 on 8/17/24.
//

import UIKit
import CoreCommonKit
import SnapKit
import Then

public final class FilterEmptyView: BaseView {
    let container = UIView()
    let imageView = UIImageView().then {
        $0.image = .grFilter
        $0.contentMode = .scaleAspectFit
    }
    let titleLabel = PurithmLabel(typography: Constants.titleTypo).then {
        $0.text = "아직 준비중이에요"
    }
    
    public override func setup() {
        super.setup()
        
        self.backgroundColor = .gray100
    }
    
    public override func setupSubviews() {
        addSubview(container)
        
        container.addSubview(imageView)
        container.addSubview(titleLabel)
    }
    
    public override func setupConstraints() {
        container.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { make in
            make.size.equalTo(150)
            make.center.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
        }
    }
}

extension FilterEmptyView {
    private enum Constants {
        static let titleTypo = Typography(size: .size16, weight: .medium, color: .gray400, applyLineHeight: true)
    }
}
