//
//  ArtistsView.swift
//  Author
//
//  Created by 이숭인 on 8/8/24.
//

import UIKit
import CoreUIKit
import CoreCommonKit
import SnapKit
import Then
import Combine

final class ArtistsView: BaseView {
    let headerView = PurithmHeaderView().then {
        $0.configure(with: .none(title: "Artists"))
    }
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        $0.backgroundColor = .gray100
    }
    
    override func setup() {
        super.setup()
        
        self.backgroundColor = .gray100
    }
    
    override func setupSubviews() {
        [headerView, collectionView].forEach {
            addSubview($0)
        }
    }
    
    override func setupConstraints() {
        headerView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}
