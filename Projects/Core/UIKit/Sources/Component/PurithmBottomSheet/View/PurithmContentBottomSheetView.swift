//
//  PurithmContentBottomSheetView.swift
//  CoreUIKit
//
//  Created by 이숭인 on 8/7/24.
//

import UIKit
import Combine
import Then
import SnapKit
import CoreCommonKit

public final class PurithmContentBottomSheetView: BaseView {
    private let titleLabel = PurithmLabel(typography: Constants.titleTypo)
    private let descriptionLabel = PurithmLabel(typography: Constants.descriptionTypo).then {
        $0.numberOfLines = 0
    }
    
    private let conformButton = PlainButton(type: .filled, variant: .default, size: .large).then {
        $0.text = "확인"
    }
    
    private let contentContainer = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fill
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
    }
    private let satisfactionContentView = SatisfactionBottomSheetContentView()
    private let filterRockContentView = PremiumFilterRockBottomSheetContentView()
    
    var conformTapEvent: AnyPublisher<Void, Never> {
        conformButton.tap.eraseToAnyPublisher()
    }
    
    public override func setup() {
        super.setup()
        
        self.backgroundColor = .gray100
    }
    
    public override func setupSubviews() {
        [titleLabel, descriptionLabel, contentContainer, conformButton].forEach {
            addSubview($0)
        }
        
        [satisfactionContentView, filterRockContentView].forEach {
            contentContainer.addArrangedSubview($0)
        }
    }
    
    public override func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(40)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(28)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(30)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        contentContainer.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalTo(conformButton.snp.top).offset(-40)
        }
        
        conformButton.snp.makeConstraints { make in
            make.top.equalTo(contentContainer.snp.bottom).offset(40)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
    
    func configure(with contentType: PurithmBottomSheetContentType, title: String, description: String) {
        titleLabel.text = title
        descriptionLabel.text = description
        
        switch contentType {
        case .satisfaction:
            satisfactionContentView.isHidden = false
            filterRockContentView.isHidden = true
        case .premiumFilterLock:
            satisfactionContentView.isHidden = true
            filterRockContentView.isHidden = false
        }
    }
}

extension PurithmContentBottomSheetView {
    private enum Constants {
        static let titleTypo = Typography(size: .size24, weight: .bold, color: .gray500, applyLineHeight: false)
        static let descriptionTypo = Typography(size: .size16, weight: .medium, color: .gray500, applyLineHeight: true)
    }
}
