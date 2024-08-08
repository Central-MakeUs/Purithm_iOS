//
//  FilterOptionComponent.swift
//  Filter
//
//  Created by 이숭인 on 8/6/24.
//

import UIKit
import CoreUIKit
import CoreCommonKit
import Combine

struct FilterOptionComponent: Component {
    var identifier: String
    let option: FilterOptionModel
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(option.optionType)
        hasher.combine(option.intensity)
    }
}

extension FilterOptionComponent {
    typealias ContentType = FilterOptionView
    
    func render(content: ContentType, context: Self, cancellable: inout Set<AnyCancellable>) {
        content.configure(with: context.option.optionType, intensity: context.option.intensity)
    }
}

final class FilterOptionView: BaseView {
    let container = UIView().then {
        $0.layer.cornerRadius = 40 / 2
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.white020.cgColor
    }
    let optionButton = PlainButton(type: .transparent, variant: .option, size: .small).then {
        $0.shape = .circle
        $0.hasShadow = true
        $0.hasContentShdaow = true
    }
    
    override func setup() {
        super.setup()
        self.backgroundColor = .clear
    }
    
    override func setupSubviews() {
        addSubview(container)
        
        container.addSubview(optionButton)
    }
    
    override func setupConstraints() {
        container.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(40)
        }
        
        optionButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configure(with optionType: IPhonePhotoFilter, intensity: Int) {
        optionButton.image = optionType.image
        optionButton.text = "\(optionType.rawValue) \(intensity)"
    }
}

extension FilterOptionView {
    private enum Constants {
        static let titleTypo = Typography(size: .size16, weight: .semibold, color: .white, applyLineHeight: true)
    }
}

