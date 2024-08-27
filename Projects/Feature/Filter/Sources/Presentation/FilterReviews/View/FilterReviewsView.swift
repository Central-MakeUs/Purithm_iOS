//
//  FilterReviews.swift
//  Filter
//
//  Created by 이숭인 on 8/5/24.
//

import UIKit
import CoreUIKit
import Combine

final class FilterReviewsView: BaseView {
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
    
    var conformTapEvent: AnyPublisher<Void, Never> {
        conformButton.tap
    }
    
    let emptyView = PurithmEmptyView()
    var emptyViewConformEvent: AnyPublisher<Void, Never> {
        emptyView.buttonTapPublisher
    }
    
    override func setup() {
        super.setup()
        
        self.backgroundColor = .gray100
        
        emptyView.configure(
            image: nil,
            description: "이 필터의\n첫 후기를 남겨주세요",
            buttonTitle: "후기 남기러 가기"
        )
        
        collectionView.backgroundView = emptyView
        collectionView.backgroundView?.isHidden = true
    }
    
    override func setupSubviews() {
        [collectionView, bottomGradientView, conformButton].forEach {
            addSubview($0)
        }
    }
    
    override func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
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
    
    func updateConformButton(with recordModel: FilterRecordForMeModel) {
        conformButton.text = "필터값 보기"
        
        if recordModel.hasReview && !recordModel.myReviewID.isEmpty {
            conformButton.text = "내가 남긴 후기 보기"
        } else if recordModel.hasViewd {
            conformButton.text = "후기 남기고 스탬프 받기"
        }
    }
    
    func showEmptyViewIfNeeded(with isEmpty: Bool) {
        collectionView.backgroundView?.isHidden = !isEmpty
        conformButton.isHidden = isEmpty
    }
}
