//
//  TermsAndConditionsView.swift
//  Login
//
//  Created by 이숭인 on 7/18/24.
//

import UIKit
import SnapKit
import Then

import CoreUIKit
import CoreCommonKit

extension TermsAndConditionsView {
    enum Constants {
        static let agreeButtonTypo = Typography(size: .size16, weight: .semibold, color: .white, applyLineHeight: true)
    }
}

final class TermsAndConditionsView: BaseView {
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        $0.backgroundColor = .clear
    }
    
    let agreeButton = UIButton(typography: Constants.agreeButtonTypo, type: .custom).then {
        $0.setTitle("가입 완료", for: .normal)
        $0.setBackgroundColor(.gray200, for: .disabled)
        $0.setBackgroundColor(.blue400, for: .normal)
        $0.isEnabled = false
        $0.round(with: 12)
    }
    
    override func setupSubviews() {
        [collectionView, agreeButton].forEach {
            addSubview($0)
        }
    }
    
    override func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(16)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalTo(agreeButton.snp.top).offset(-16)
        }
        
        agreeButton.snp.makeConstraints { make in
            make.height.equalTo(56)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(16)
        }
    }
    
    func updateButtonState(with isEnabled: Bool) {
        agreeButton.isEnabled = isEnabled
    }
}
