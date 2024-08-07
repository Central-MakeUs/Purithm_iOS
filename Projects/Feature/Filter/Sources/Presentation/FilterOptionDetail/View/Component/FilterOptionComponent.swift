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
    let imageView = UIImageView()
    let titleLabel = PurithmLabel(typography: Constants.titleTypo)
    
    override func setup() {
        super.setup()
        self.backgroundColor = .clear
    }
    
    override func setupSubviews() {
        addSubview(container)
        
        container.addSubview(imageView)
        container.addSubview(titleLabel)
    }
    
    override func setupConstraints() {
        container.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(40)
        }
        
        imageView.snp.makeConstraints { make in
            make.size.equalTo(20)
            make.leading.equalToSuperview().inset(12)
            make.verticalEdges.equalToSuperview().inset(10)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(imageView.snp.trailing).offset(6)
            make.verticalEdges.equalToSuperview().inset(10)
            make.trailing.equalToSuperview().inset(12)
        }
    }
    
    func configure(with optionType: IPhonePhotoFilter, intensity: Int) {
        imageView.image = optionType.image.withTintColor(.white)
        titleLabel.text = "\(optionType.rawValue) \(intensity)"
    }
}

extension FilterOptionView {
    private enum Constants {
        static let titleTypo = Typography(size: .size16, weight: .semibold, color: .white, applyLineHeight: true)
    }
}

