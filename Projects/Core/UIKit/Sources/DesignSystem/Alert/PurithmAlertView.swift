//
//  PurithmAlertView.swift
//  CoreUIKit
//
//  Created by 이숭인 on 7/26/24.
//

import UIKit
import SnapKit
import Then
import CoreCommonKit

extension PurithmAlertView {
    enum Constants {
        static let alertLabelTypo = Typography(size: .size18, weight: .semibold, alignment: .center, color: .gray500, applyLineHeight: true)
        
        static let contentTypo = Typography(size: .size16, weight: .medium, alignment: .center, color: .gray400, applyLineHeight: true)
    }
}

public final class PurithmAlertView: BaseView {
    let backgroundView = UIView().then {
        $0.backgroundColor = .clear
    }
    private let container = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
    }
    
    private let textContainer = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fillProportionally
        $0.alignment = .center
    }
    private let alertLabel = PurithmLabel(typography: Constants.alertLabelTypo).then {
        $0.numberOfLines = 0
    }
    private let alertContentLabel = PurithmLabel(typography: Constants.contentTypo).then {
        $0.numberOfLines = 0
    }
    private let buttonStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 0
        $0.alignment = .center
        $0.distribution = .fillEqually
    }
    let cancelButton = TextButton(variant: .secondary, size: .large)
    let conformButton = TextButton(variant: .primary, size: .large)
    
    public override func setupSubviews() {
        addSubview(backgroundView)
        addSubview(container)
        
        [textContainer, buttonStackView].forEach {
            container.addSubview($0)
        }
        
        buttonStackView.addArrangedSubview(cancelButton)
        buttonStackView.addArrangedSubview(conformButton)
        
        textContainer.addArrangedSubview(alertLabel)
        textContainer.addArrangedSubview(alertContentLabel)
    }
    
    public override func setupConstraints() {
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        container.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(40)
        }
        
        textContainer.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(textContainer.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    func configure(
        title: String,
        content: String = "",
        conformTitle: String,
        cancelTitle: String = ""
    ) {
        alertLabel.text = title
        alertContentLabel.text = content
        conformButton.text = conformTitle
        cancelButton.text = cancelTitle
        
        if cancelTitle.isEmpty {
            cancelButton.isHidden = true
        }
    }
}

