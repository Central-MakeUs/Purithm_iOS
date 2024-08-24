//
//  ProfileMyWishlistView.swift
//  Profile
//
//  Created by 이숭인 on 8/22/24.
//

import UIKit
import CoreUIKit
import CoreCommonKit
import Combine

final class ProfileMyWishlistView: BaseView {
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
            image: .grHeart,
            description: "마음에 든 필터가 있다면\n찜 아이콘을 눌러 보세요",
            buttonTitle: nil
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
