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
    
    let chipCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        $0.backgroundColor = .gray100
    }
    let chipRightGradientView = PurithmGradientView().then {
        $0.colorType = .white(direction: .leading)
    }
    
    public override func setupSubviews() {
        self.backgroundColor = .gray100
        
        [headerView, chipCollectionView, filterCollectionView].forEach {
            addSubview($0)
        }
        
        addSubview(chipRightGradientView)
        
        let emptyView = PurithmEmptyView()
        emptyView.configure(
            image: .grFilter,
            description: "아직 준비중이에요", 
            buttonTitle: nil
        )
        
        filterCollectionView.backgroundView = emptyView
        filterCollectionView.backgroundView?.isHidden = true
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
        
        chipRightGradientView.snp.makeConstraints { make in
            make.width.equalTo(20)
            make.trailing.equalTo(chipCollectionView.snp.trailing)
            make.verticalEdges.equalTo(chipCollectionView)
        }
        
        chipRightGradientView.snp.makeConstraints { make in
            make.width.equalTo(20)
            make.trailing.equalTo(chipCollectionView.snp.trailing)
            make.verticalEdges.equalTo(chipCollectionView)
        }
        
        filterCollectionView.snp.makeConstraints { make in
            make.top.equalTo(chipCollectionView.snp.bottom).offset(10)
            make.bottom.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
        }
    }
    
    func configure(with type: PurithmHeaderType) {
        headerView.configure(with: type)
    }
    
    func showEmptyViewIfNeeded(with isEmpty: Bool) {
        filterCollectionView.backgroundView?.isHidden = !isEmpty
    }
}
