//
//  FiltersSkeletonView.swift
//  Filter
//
//  Created by 이숭인 on 8/28/24.
//


import UIKit
import CoreUIKit
import SkeletonView

final class FiltersSkeletonView: BaseView {
    let firstView = UIView()
    let secondView = UIView()
    let thirdView = UIView()
    let fourthView = UIView()
    
    override func setup() {
        super.setup()
        
        self.backgroundColor = .clear
        
        [firstView, secondView, thirdView, fourthView].forEach {
            $0.isSkeletonable = true
        }
    }
    
    override func setupSubviews() {
        [firstView, secondView, thirdView, fourthView].forEach {
            $0.layer.cornerRadius = 12
            $0.clipsToBounds = true
            addSubview($0)
        }
    }
    
    override func setupConstraints() {
        let views = [firstView, secondView, thirdView, fourthView]
        
        views.forEach { view in
            view.snp.makeConstraints { make in
                make.width.equalToSuperview().dividedBy(2).offset(-30)
                make.height.equalTo(view.snp.width).multipliedBy(1.25)
            }
        }
        
        // Constraints for the first view (top-left)
        firstView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(20)
        }
        
        // Constraints for the second view (top-right)
        secondView.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(20)
            make.leading.equalTo(firstView.snp.trailing).offset(20)
        }
        
        // Constraints for the third view (bottom-left)
        thirdView.snp.makeConstraints { make in
            make.top.equalTo(firstView.snp.bottom).offset(20)
            make.leading.equalToSuperview().inset(20)
        }
        
        // Constraints for the fourth view (bottom-right)
        fourthView.snp.makeConstraints { make in
            make.top.equalTo(secondView.snp.bottom).offset(20)
            make.leading.equalTo(thirdView.snp.trailing).offset(20)
        }
    }
}
