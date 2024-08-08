//
//  PurithmMenuBottomSheetMenuView.swift
//  CoreUIKit
//
//  Created by 이숭인 on 8/7/24.
//

import UIKit
import SnapKit
import Then

final class PurithmMenuBottomSheetMenuView: BaseView {
    let container = UIView().then {
        $0.isUserInteractionEnabled = true
    }
    let label = PurithmLabel(typography: Constants.labelTypo).then {
        $0.isUserInteractionEnabled = false
    }
    let labelTapGesture = UITapGestureRecognizer()
    
    override func setupSubviews() {
        addSubview(container)
        
        container.addSubview(label)
        container.addGestureRecognizer(labelTapGesture)
    }
    
    override func setupConstraints() {
        container.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(58)
        }
        
        label.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(20)
            make.verticalEdges.equalToSuperview()
        }
    }
    
    func configure(with menu: PurithmMenuModel) {
        label.text = menu.title
        label.textColor = menu.isSelected ? .gray500 : .gray300
    }
}

extension PurithmMenuBottomSheetMenuView {
    private enum Constants {
        static let labelTypo = Typography(size: .size18, weight: .semibold, color: .gray500, applyLineHeight: true)
    }
}
