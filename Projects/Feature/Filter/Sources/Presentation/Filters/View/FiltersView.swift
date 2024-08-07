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
    let headerView = PurithmHeaderView()
    
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
        
        [headerView, chipCollectionView, filterCollectionView].forEach {
            addSubview($0)
        }
        
        [chipLeftGradientView, chipRightGradientView, filterTopGradientView, filterBottomGradientView].forEach {
            addSubview($0)
        }
    }
    
    public override func setupConstraints() {
        headerView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
        }
        
        chipCollectionView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(10)
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
    
    func configure(with type: PurithmHeaderType) {
        headerView.configure(with: type)
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
