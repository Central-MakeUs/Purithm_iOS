//
//  FilterDetailHeaderView.swift
//  Filter
//
//  Created by 이숭인 on 7/30/24.
//

import UIKit
import CoreUIKit
import CoreCommonKit
import Combine

final class FilterDetailHeaderView: BaseView {
    var cancellables = Set<AnyCancellable>()
    
    let headerContainer = UIView()
    let backButton = UIButton().then {
        $0.setImage(.icArrowLeft, for: .normal)
    }
    let detailTitleLabel = PurithmLabel(typography: Constants.titleTypo)
    
    let likeContainer = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fillProportionally
    }
    let likeButton = UIButton().then {
        $0.setImage(.icLikeUnpressed.withTintColor(.gray300), for: .normal)
        $0.setImage(.icLikePressed.withTintColor(.blue400), for: .selected)
    }
    let likeCountLabel = PurithmLabel(typography: Constants.likeCountTypo)
    
    override func setup() {
        super.setup()
    }
    
    override func setupSubviews() {
        addSubview(headerContainer)
        
        [backButton, detailTitleLabel, likeContainer].forEach {
            headerContainer.addSubview($0)
        }
        
        [likeButton, likeCountLabel].forEach {
            likeContainer.addArrangedSubview($0)
        }
    }
    
    override func setupConstraints() {
        headerContainer.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        backButton.snp.makeConstraints { make in
            make.size.equalTo(24)
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        detailTitleLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(10)
            make.leading.equalTo(backButton.snp.trailing).offset(12)
            make.trailing.equalTo(likeContainer.snp.leading).offset(-12)
        }
        
        likeButton.snp.makeConstraints { make in
            make.size.equalTo(24)
        }
        
        likeContainer.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
    func configure(title: String, likeCount: Int, isLike: Bool) {
        detailTitleLabel.text = title
        likeCountLabel.text = "\(likeCount)"
        
        likeButton.isSelected = isLike
    }
}

extension FilterDetailHeaderView {
    private enum Constants {
        static let titleTypo = Typography(size: .size32, weight: .medium, color: .gray500, applyLineHeight: true)
        static let likeCountTypo = Typography(size: .size12, weight: .medium, alignment: .center, color: .gray300, applyLineHeight: true)
    }
}
