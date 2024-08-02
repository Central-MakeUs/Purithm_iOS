//
//  FiltersView.swift
//  Filter
//
//  Created by 이숭인 on 7/28/24.
//

import UIKit
import CoreUIKit
import CoreCommonKit
import SnapKit

extension FiltersView {
    enum Constants {
        static let titleTypo = Typography(size: .size32, weight: .medium, color: .gray500, applyLineHeight: true)
    }
}

public final class FiltersView: BaseView {
    let headerContainer = UIView().then {
        $0.backgroundColor = .gray100
    }
    let headerTitleLabel = UILabel(typography: Constants.titleTypo).then {
        $0.text = "Filters"
    }
    let headerLikeButton = UIButton().then {
        $0.setImage(.icLikeUnpressed, for: .normal)
    }
    
    let filterCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        $0.backgroundColor = .gray100
        $0.showsVerticalScrollIndicator = false
    }
    
    public override func setupSubviews() {
        self.backgroundColor = .gray100
        
        [headerContainer, filterCollectionView].forEach {
            addSubview($0)
        }
        
        headerContainer.addSubview(headerTitleLabel)
        headerContainer.addSubview(headerLikeButton)
    }
    
    public override func setupConstraints() {
        headerContainer.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        headerTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.verticalEdges.equalToSuperview().inset(10)
            make.trailing.equalTo(headerLikeButton.snp.leading).offset(8)
        }
        
        headerLikeButton.snp.makeConstraints { make in
            make.size.equalTo(24)
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        filterCollectionView.snp.makeConstraints { make in
            make.top.equalTo(headerContainer.snp.bottom).offset(10)
            make.bottom.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
        }
    }
}
