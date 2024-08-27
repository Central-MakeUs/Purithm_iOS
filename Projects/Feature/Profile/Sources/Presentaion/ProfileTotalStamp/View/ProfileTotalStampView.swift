//
//  ProfileTotalStampView.swift
//  Profile
//
//  Created by 이숭인 on 8/23/24.
//

import UIKit
import CoreUIKit
import CoreCommonKit
import Combine

final class ProfileTotalStampView: BaseView {
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        $0.backgroundColor = .gray100
    }
    
    let emptyView = PurithmEmptyView()
    var emptyViewConformEvent: AnyPublisher<Void, Never> {
        emptyView.buttonTapPublisher
    }
    
    override func setup() {
        super.setup()
        
        self.backgroundColor = .gray100
        
        emptyView.configure(
            image: .grFlower,
            description: "후기 남기고\n스탬프를 채워 보세요",
            buttonTitle: "후기 남기러 가기"
        )
        
        collectionView.backgroundView = emptyView
        collectionView.backgroundView?.isHidden = true
    }
    
    override func setupSubviews() {
        addSubview(collectionView)
    }
    
    override func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func showEmptyViewIfNeeded(with isEmpty: Bool) {
        collectionView.backgroundView?.isHidden = !isEmpty
    }
}
