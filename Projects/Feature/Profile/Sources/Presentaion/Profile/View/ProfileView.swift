//
//  ProfileView.swift
//  Profile
//
//  Created by 이숭인 on 8/21/24.
//

import UIKit
import CoreUIKit
import CoreCommonKit

final class ProfileView: BaseView {
    let collectionView = UICollectionView(frame: .zero,
                                          collectionViewLayout: UICollectionViewFlowLayout()).then {
        $0.backgroundColor = .gray100
    }
    
    override func setupSubviews() {
        self.backgroundColor = .gray100
        addSubview(collectionView)
    }
    
    override func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
