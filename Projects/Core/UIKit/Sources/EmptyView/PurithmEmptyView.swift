//
//  PurithmEmptyView.swift
//  CoreUIKit
//
//  Created by 이숭인 on 8/17/24.
//

import UIKit
import CoreCommonKit
import SnapKit
import Then
import Combine

public final class PurithmEmptyView: BaseView {
    let container = UIView()
    let imageView = UIImageView().then {
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFit
    }
    let descriptionLabel = PurithmLabel(typography: Constants.descriptionLabelTypo).then {
        $0.numberOfLines = 0
    }
    let conformButton = PlainButton(type: .filled, variant: .default, size: .medium)
    
    public var buttonTapPublisher: AnyPublisher<Void, Never> {
        conformButton.tap
    }
    
    public override func setup() {
        super.setup()
        
        self.backgroundColor = .gray100
        imageView.isHidden = true
        conformButton.isHidden = true
    }
    
    public override func setupSubviews() {
        addSubview(container)
        
        container.addSubview(imageView)
        container.addSubview(descriptionLabel)
        container.addSubview(conformButton)
    }
    
    public override func setupConstraints() {
        container.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { make in
            make.size.equalTo(150)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(descriptionLabel.snp.top).offset(-30)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(30)
            make.center.equalToSuperview()
        }
        
        conformButton.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
    }
    
    public func configure(image: UIImage?, description: String, buttonTitle: String?) {
        if image != nil {
            imageView.image = image
            imageView.isHidden = false
        }
        
        if buttonTitle != nil {
            conformButton.text = buttonTitle
            conformButton.isHidden = false
        }
        
        descriptionLabel.text = description
    }
}

extension PurithmEmptyView {
    private enum Constants {
        static let descriptionLabelTypo = Typography(size: .size16, weight: .medium, alignment: .center, color: .gray400, applyLineHeight: true)
    }
}
