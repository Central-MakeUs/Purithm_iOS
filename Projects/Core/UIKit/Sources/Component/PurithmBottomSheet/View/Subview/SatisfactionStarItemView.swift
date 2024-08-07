//
//  SatisfactionStarItemView.swift
//  CoreUIKit
//
//  Created by 이숭인 on 8/7/24.
//

import UIKit
import CoreCommonKit
import SnapKit
import Then

final class SatisfactionStarItemView: BaseView {
    let imageView = UIImageView()
    let label = PurithmLabel(typography: Constants.titleTypo)
    
    override func setupSubviews() {
        [imageView, label].forEach {
            addSubview($0)
        }
    }
    
    override func setupConstraints() {
        imageView.snp.makeConstraints { make in
            make.size.equalTo(20)
            make.verticalEdges.equalToSuperview()
            make.leading.equalToSuperview()
        }
        
        label.snp.makeConstraints { make in
            make.leading.equalTo(imageView.snp.trailing).offset(2)
            make.verticalEdges.equalToSuperview()
            make.trailing.equalToSuperview()
        }
    }
    
    func configure(with type: SatisfactionLevel) {
        imageView.image = type.starImage.withTintColor(type.color)
        label.text = "\(type.rawValue) %"
        label.textColor = type.color
    }
}

extension SatisfactionStarItemView {
    private enum Constants {
        static let titleTypo = Typography(size: .size16, weight: .semibold, color: .gray500, applyLineHeight: true)
    }
}
