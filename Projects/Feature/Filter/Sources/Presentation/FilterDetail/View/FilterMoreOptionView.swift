//
//  FilterMoreOptionView.swift
//  Filter
//
//  Created by 이숭인 on 7/30/24.
//

import UIKit
import CoreUIKit
import CoreCommonKit
import Combine
import CombineCocoa

final class FilterMoreOptionView: BaseView {
    var tapEvent: AnyPublisher<FilterDetailOptionType?, Never> {
        viewTapGesture.tapPublisher
            .map { [weak self] _ in
                return self?.optionType
            }
            .eraseToAnyPublisher()
    }
    
    private let viewTapGesture = UITapGestureRecognizer()
    let leftImageView = UIImageView().then {
        $0.image = .icStarHigh.withTintColor(.gray300)
    }
    let optionTitleLabel = PurithmLabel(typography: Constants.titleTypo)
    let rightImageView = UIImageView().then {
        $0.image = .icMove.withTintColor(.gray300)
    }
    
    private var optionType: FilterDetailOptionType?
    
    override func setup() {
        super.setup()
     
        self.addGestureRecognizer(viewTapGesture)
        self.backgroundColor = .gray100
    }
    
    override func setupSubviews() {
        [leftImageView, optionTitleLabel, rightImageView].forEach {
            addSubview($0)
        }
    }
    
    override func setupConstraints() {
        leftImageView.snp.makeConstraints { make in
            make.size.equalTo(18)
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
            make.verticalEdges.lessThanOrEqualToSuperview()
        }
        
        optionTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(leftImageView.snp.trailing).offset(2)
            make.verticalEdges.equalToSuperview().inset(2)
            make.trailing.equalTo(rightImageView.snp.leading).offset(-2)
        }
        
        rightImageView.snp.makeConstraints { make in
            make.size.equalTo(18)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
            make.verticalEdges.lessThanOrEqualToSuperview()
        }
    }
    
    func configure(with optionType: FilterDetailOptionType) {
        self.optionType = optionType
        
        optionTitleLabel.text = optionType.title
        
        leftImageView.image = optionType.leftImage.withTintColor(.gray300)
        rightImageView.image = optionType.rightImage.withTintColor(.gray300)
    }
}

extension FilterMoreOptionView {
    private enum Constants {
        static let titleTypo = Typography(size: .size14, weight: .semibold, color: .gray300, applyLineHeight: true)
    }
}
