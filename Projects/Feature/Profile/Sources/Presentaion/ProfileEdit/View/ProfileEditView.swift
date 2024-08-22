//
//  ProfileEditView.swift
//  Profile
//
//  Created by 이숭인 on 8/22/24.
//

import UIKit
import CoreUIKit

final class ProfileEditView: BaseView {
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        $0.backgroundColor = .gray100
    }
    let tapGesture = UITapGestureRecognizer()
    
    override func setup() {
        super.setup()
        
        self.backgroundColor = .gray100
        self.addGestureRecognizer(tapGesture)
    }
    
    override func setupSubviews() {
        addSubview(collectionView)
    }
    
    override func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
