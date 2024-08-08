//
//  FilterDescriptionView.swift
//  Filter
//
//  Created by 이숭인 on 8/3/24.
//

import UIKit
import CoreUIKit


extension FilterDescriptionView {
    private enum Constants {
        static let titleTypo = Typography(size: .size36, weight: .medium, color: .gray500, applyLineHeight: true)
        static let subTitleTypo = Typography(size: .size21, weight: .medium , color: .blue400, applyLineHeight: true)
    }
}

final class FilterDescriptionView: BaseView {
    private let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
    }
    private let contentView = UIView()
    
    let headerDescriptionView = FilterDescriptionItemView()
    let firstDescriptionView = FilterDescriptionItemView()
    let secondDescriptionView = FilterDescriptionItemView()
    
    override func setupSubviews() {
        self.backgroundColor = .gray100
        
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(headerDescriptionView)
        contentView.addSubview(firstDescriptionView)
        contentView.addSubview(secondDescriptionView)
    }
    
    override func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView)
        }
        
        headerDescriptionView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }
        
        firstDescriptionView.snp.makeConstraints { make in
            make.top.equalTo(headerDescriptionView.snp.bottom).offset(40)
            make.horizontalEdges.equalToSuperview()
        }
        
        secondDescriptionView.snp.makeConstraints { make in
            make.top.equalTo(firstDescriptionView.snp.bottom).offset(40)
            make.horizontalEdges.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
        }
    }
    
    func configure(with descriptions: [FilterDescriptionModel]) {
        if let header = descriptions[safe: 0] {
            headerDescriptionView.configure(with: header)
        }
        
        if let firstContent = descriptions[safe: 1] {
            firstDescriptionView.configure(with: firstContent)
        }
        
        if let secondContent = descriptions[safe: 2] {
            secondDescriptionView.configure(with: secondContent)
        }
    }
}
