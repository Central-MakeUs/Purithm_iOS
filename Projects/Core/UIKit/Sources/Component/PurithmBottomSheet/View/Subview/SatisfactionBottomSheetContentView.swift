//
//  SatisfactionBottomSheetContentView.swift
//  CoreUIKit
//
//  Created by 이숭인 on 8/7/24.
//

import UIKit
import CoreCommonKit
import SnapKit
import Then

final class SatisfactionBottomSheetContentView: BaseView {
    let container = UIView().then {
        $0.backgroundColor = .white
    }
    
    let satisfactionStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillProportionally
        $0.spacing = 10
    }
    let satisfactionItemViews: [SatisfactionStarItemView] = SatisfactionLevel.allCases.map { level in
        let view = SatisfactionStarItemView()
        view.configure(with: level)
        return view
    }
    let satisfactionImageView = UIImageView().then {
        $0.image = .satisfactionIndenty
        $0.contentMode = .scaleAspectFill
    }
    
    override func setupSubviews() {
        addSubview(container)
        container.addSubview(satisfactionStackView)
        container.addSubview(satisfactionImageView)
        
        satisfactionItemViews.forEach {
            satisfactionStackView.addArrangedSubview($0)
        }
    }
    
    override func setupConstraints() {
        container.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(12)
            make.verticalEdges.equalToSuperview().inset(20)
        }
        
        satisfactionStackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        satisfactionImageView.snp.makeConstraints { make in
            make.top.equalTo(satisfactionStackView.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(40)
        }
    }
}
