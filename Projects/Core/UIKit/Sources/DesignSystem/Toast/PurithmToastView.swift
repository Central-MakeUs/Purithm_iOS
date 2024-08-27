//
//  PurithmToastView.swift
//  CoreUIKit
//
//  Created by 이숭인 on 8/26/24.
//

import UIKit
import SnapKit
import Then
import CoreCommonKit

public final class PurithmToastView: BaseView {
    let toastContainer = UIView().then  {
        $0.layer.cornerRadius = 12
        $0.backgroundColor = .blue400
    }
    let toastMessageLabel = PurithmLabel(typography: Constants.toastMessageTypo)
    let optionLabel = PurithmLabel(typography: Constants.optionTypo).then {
        $0.isUserInteractionEnabled = true
    }
    let optionTapGesture = UITapGestureRecognizer()
    
    public override func setup() {
        super.setup()
        
        self.backgroundColor = .clear
        optionLabel.addGestureRecognizer(optionTapGesture)
    }
    
    public override func setupSubviews() {
        addSubview(toastContainer)
        
        toastContainer.addSubview(toastMessageLabel)
        toastContainer.addSubview(optionLabel)
    }
    
    public override func setupConstraints() {
        toastContainer.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(60)
        }
        
        toastMessageLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(20)
            make.trailing.equalTo(optionLabel.snp.leading).offset(-8)
        }
        
        optionLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(20)
            make.leading.equalTo(toastMessageLabel.snp.trailing).offset(8)
        }
    }
    
    func configure(message: String, direction: PurithmToastType, optionTitle: String?) {
        toastMessageLabel.text = message
        optionLabel.text = optionTitle
        
        switch direction {
        case .top:
            toastContainer.snp.remakeConstraints { make in
                make.top.equalTo(safeAreaLayoutGuide).inset(40)
                make.horizontalEdges.equalToSuperview().inset(20)
                make.height.equalTo(60)
            }
        case .bottom:
            toastContainer.snp.remakeConstraints { make in
                make.horizontalEdges.equalToSuperview().inset(20)
                make.height.equalTo(60)
                make.bottom.equalTo(safeAreaLayoutGuide).inset(40)
            }
        }
    }
}

extension PurithmToastView {
    private enum Constants {
        static let toastMessageTypo = Typography(size: .size16, weight: .medium, color: .white, applyLineHeight: true)
        static let optionTypo = Typography(size: .size16, weight: .semibold, color: .white, applyLineHeight: true)
    }
}
