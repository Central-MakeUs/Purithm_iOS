//
//  ReviewView.swift
//  Review
//
//  Created by 이숭인 on 8/9/24.
//

import UIKit
import CoreUIKit
import CoreCommonKit

public final class ReviewView: BaseView {
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        $0.backgroundColor = .gray100
    }
    
    public override func setupSubviews() {
        addSubview(collectionView)
    }
    
    public override func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
}
