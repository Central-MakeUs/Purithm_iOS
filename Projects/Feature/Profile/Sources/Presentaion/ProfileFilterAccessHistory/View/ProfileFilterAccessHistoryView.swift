//
//  ProfileFilterAccessHistoryView.swift
//  Profile
//
//  Created by 이숭인 on 8/22/24.
//

import UIKit
import CoreUIKit
import CoreCommonKit

final class ProfileFilterAccessHistoryView: BaseView {
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        $0.backgroundColor = .gray100
    }
    
    override func setup() {
        super.setup()
        
        self.backgroundColor = .gray100
        
        let emptyView = PurithmEmptyView()
        emptyView.configure(
            image: .grFilter,
            description: "열람한 필터가 존재하지 않습니다",
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
