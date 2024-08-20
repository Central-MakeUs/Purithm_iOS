//
//  FilterDetailReviewListView.swift
//  Filter
//
//  Created by 이숭인 on 8/5/24.
//

import UIKit
import CoreUIKit
import CoreCommonKit

final class FilterDetailReviewListView: BaseView {
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        $0.backgroundColor = .gray100
        $0.showsVerticalScrollIndicator = false
    }
    
    let conformButton = PlainButton(type: .filled, variant: .default, size: .large).then {
        $0.text = "후기 남기고 스탬프 받기"
    }
    
    let bottomGradientView = PurithmGradientView().then {
        $0.colorType = .white(direction: .top)
    }
    
    override func setup() {
        super.setup()
        self.backgroundColor = .gray100
        
        conformButton.isHidden = true
    }
    
    override func setupSubviews() {
        [collectionView, bottomGradientView, conformButton].forEach {
            addSubview($0)
        }
    }
    
    override func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalToSuperview()
        }
        
        conformButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalTo(safeAreaLayoutGuide)
        }
        
        bottomGradientView.snp.makeConstraints { make in
            make.height.equalTo(120)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}
