//
//  FeedsView.swift
//  Feed
//
//  Created by 이숭인 on 8/8/24.
//

import UIKit
import CoreUIKit
import CoreCommonKit
import SnapKit

final class FeedsView: BaseView {
    let headerView = PurithmHeaderView().then {
        $0.configure(with: .none(title: "Feed"))
        $0.backgroundColor = .gray100
    }
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        $0.showsVerticalScrollIndicator = false
    }
    
    let topGradientView = PurithmGradientView().then {
        $0.colorType = .white(direction: .bottom)
    }
    
    override func setup() {
        super.setup()
        
        self.backgroundColor = .gray100
        self.collectionView.backgroundColor = .gray100
    }
    
    override func setupSubviews() {
        [headerView, collectionView, topGradientView].forEach {
            addSubview($0)
        }
    }
    
    override func setupConstraints() {
        headerView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
        }
        
        topGradientView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(20)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalToSuperview()
        }
    }
}
