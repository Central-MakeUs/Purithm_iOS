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
    let headerTitleLabel = PurithmLabel(typography: Constants.titleTypo).then {
        $0.text = "Filters"
    }
    let headerLikeButton = UIButton().then {
        $0.setImage(.icLikeUnpressed, for: .normal)
    }
    
    let filterCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        $0.backgroundColor = .gray100
        $0.showsVerticalScrollIndicator = false
    }
    let filterTopGradientView = PurithmGradientView().then {
        $0.colorType = .white(direction: .bottom)
    }
    let filterBottomGradientView = PurithmGradientView().then {
        $0.colorType = .white(direction: .top)
    }
    
    let chipCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        $0.backgroundColor = .gray100
    }
    let chipLeftGradientView = PurithmGradientView().then {
        $0.colorType = .white(direction: .trailing)
    }
    let chipRightGradientView = PurithmGradientView().then {
        $0.colorType = .white(direction: .leading)
    }
    
    public override func setupSubviews() {
        self.backgroundColor = .gray100
        
        [headerContainer, chipCollectionView, filterCollectionView].forEach {
            addSubview($0)
        }
        
        [chipLeftGradientView, chipRightGradientView, filterTopGradientView, filterBottomGradientView].forEach {
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
        
        //TODO: 이거 헤더뷰로 바꾸자 ㅇㅇ
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
        
        chipCollectionView.snp.makeConstraints { make in
            make.top.equalTo(headerContainer.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(36)
        }
        setupConstraintChipGradient() // chip gradient
        
        filterCollectionView.snp.makeConstraints { make in
            make.top.equalTo(chipCollectionView.snp.bottom).offset(10)
            make.bottom.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
        }
        setupConstraintFilterGradient() // filter gradient
    }
    
    private func setupConstraintChipGradient() {
        chipLeftGradientView.snp.makeConstraints { make in
            make.width.equalTo(20)
            make.leading.equalTo(chipCollectionView.snp.leading)
            make.verticalEdges.equalTo(chipCollectionView)
        }
        chipRightGradientView.snp.makeConstraints { make in
            make.width.equalTo(20)
            make.trailing.equalTo(chipCollectionView.snp.trailing)
            make.verticalEdges.equalTo(chipCollectionView)
        }
    }
    
    private func setupConstraintFilterGradient() {
        filterTopGradientView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(filterCollectionView)
            make.top.equalTo(filterCollectionView.snp.top)
            make.height.equalTo(10)
        }
        
        filterBottomGradientView.snp.makeConstraints { make in
            make.bottom.equalTo(filterCollectionView.snp.bottom)
            make.horizontalEdges.equalTo(filterCollectionView)
            make.height.equalTo(10)
        }
    }
}
