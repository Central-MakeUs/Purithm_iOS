//
//  OptionHelpBottomSheetContentView.swift
//  CoreUIKit
//
//  Created by 이숭인 on 8/7/24.
//

import UIKit
import CoreCommonKit
import SnapKit
import Then

final class OptionHelpBottomSheetContentView: BaseView {
    private let container = UIView().then {
        $0.backgroundColor = .white
    }
    
    let titleContainer = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillProportionally
        $0.spacing = 5
    }
    let numberImageView = UIImageView()
    let titleLabel = PurithmLabel(typography: Constants.titleTypo)
    
    let helpImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
    }
    
    override func setupSubviews() {
        addSubview(container)
        
        container.addSubview(titleContainer)
        titleContainer.addArrangedSubview(numberImageView)
        titleContainer.addArrangedSubview(titleLabel)
        
        container.addSubview(helpImageView)
    }
    
    override func setupConstraints() {
        container.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        titleContainer.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        numberImageView.snp.makeConstraints { make in
            make.size.equalTo(20)
        }
        
        helpImageView.snp.makeConstraints { make in
            make.top.equalTo(titleContainer.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(20)
        }
    }
    
    func configure(with type: PurithmOptionHelpContentType) {
        numberImageView.image = type.image.withTintColor(.blue400)
        titleLabel.text = type.title
        helpImageView.image = type.contentImage
    }
}

extension OptionHelpBottomSheetContentView {
    private enum Constants {
        static let titleTypo = Typography(size: .size16, weight: .semibold, color: .blue400, applyLineHeight: true)
    }
}
