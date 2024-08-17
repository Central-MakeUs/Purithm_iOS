//
//  ReviewView.swift
//  Review
//
//  Created by 이숭인 on 8/9/24.
//

import UIKit
import CoreUIKit
import CoreCommonKit
import Combine

public final class ReviewView: BaseView {
    let container = UIView().then {
        $0.backgroundColor = .gray100
    }
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        $0.backgroundColor = .gray100
    }
    
    let conformButton = PlainButton(type: .filled, variant: .default, size: .large).then {
        $0.text = "올리기"
    }
    
    var conformButtonTapEvent: AnyPublisher<Void, Never> {
        conformButton.tap
    }
    
    public override func setup() {
        super.setup()
        
        self.backgroundColor = .gray100
    }
    
    public override func setupSubviews() {
        addSubview(container)
        
        container.addSubview(collectionView)
        container.addSubview(conformButton)
    }
    
    public override func setupConstraints() {
        container.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(conformButton.snp.top)
        }
        
        conformButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
    
    func updateConformButtonState(with isEnabled: Bool) {
        conformButton.isEnabled = isEnabled
    }
}
