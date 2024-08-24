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
        static let tagTypo = Typography(size: .size14, weight: .medium, color: .gray400, applyLineHeight: true)
    }
}

final class FilterDescriptionView: BaseView {
    private let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
    }
    private let contentView = UIView()
    
    let descriptionHeaderView = FilterDescriptionHeader()
    
    let firstDescriptionView = FilterDescriptionItemView()
    let secondDescriptionView = FilterDescriptionItemView()
    let thirdDescriptionView = FilterDescriptionItemView()
    
    let tagLabel = PurithmLabel(typography: Constants.tagTypo).then {
        $0.numberOfLines = 0
    }
    
    override func setupSubviews() {
        self.backgroundColor = .gray100
        
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(descriptionHeaderView)
        contentView.addSubview(firstDescriptionView)
        contentView.addSubview(secondDescriptionView)
        contentView.addSubview(thirdDescriptionView)
        contentView.addSubview(tagLabel)
    }
    
    override func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView)
        }
        
        descriptionHeaderView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        firstDescriptionView.snp.makeConstraints { make in
            make.top.equalTo(descriptionHeaderView.snp.bottom).offset(40)
            make.horizontalEdges.equalToSuperview()
        }
        
        secondDescriptionView.snp.makeConstraints { make in
            make.top.equalTo(firstDescriptionView.snp.bottom).offset(40)
            make.horizontalEdges.equalToSuperview()
        }
        
        thirdDescriptionView.snp.makeConstraints { make in
            make.top.equalTo(secondDescriptionView.snp.bottom).offset(40)
            make.horizontalEdges.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
        }
        
        tagLabel.snp.makeConstraints { make in
            make.top.equalTo(thirdDescriptionView.snp.bottom).offset(40)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalToSuperview()
        }
    }
    
    func configure(with descriptionModel: FilterDescriptionModel) {
        descriptionHeaderView.configure(with: descriptionModel)
        
        if let firstContent = descriptionModel.photos[safe: 0] {
            firstDescriptionView.configure(with: firstContent)
        }
        
        if let secondContent = descriptionModel.photos[safe: 1] {
            secondDescriptionView.configure(with: secondContent)
        }
        
        if let thirdContent = descriptionModel.photos[safe: 2] {
            thirdDescriptionView.configure(with: thirdContent)
        }
        
        tagLabel.text = descriptionModel.tags.map { "#\($0)" }.joined(separator: ", ")
    }
}
