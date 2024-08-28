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
    
    let emptyView = PurithmEmptyView()
    let loadingView = PurithmLoadingView()
    
    override func setup() {
        super.setup()
        
        self.backgroundColor = .gray100
        
        emptyView.configure(
            image: .grFilter,
            description: "아직 준비중이에요",
            buttonTitle: nil
        )
    }
    
    override func setupSubviews() {
        [headerView, collectionView, loadingView].forEach {
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
        
        loadingView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    func showEmptyViewIfNeeded(with isEmpty: Bool) {
        collectionView.backgroundView = emptyView
        collectionView.backgroundView?.isHidden = !isEmpty
    }
    
    func showLoadingViewInNeeded(with isShow: Bool) {
        let delay = isShow ? 0.0 : 0.3
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            self?.loadingView.isHidden = !isShow
            self?.loadingView.showActivityIndicatorIfNeeded(with: isShow)
        }
    }
}
