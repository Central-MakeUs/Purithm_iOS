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

final class TermsAndConditionsView: BaseView {
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    let agreeButton = UIButton().then {
        $0.setTitle("가입 완료", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .systemBlue
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
}
