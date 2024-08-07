//
//  FilterChipComponent.swift
//  Filter
//
//  Created by 이숭인 on 7/28/24.
//

import UIKit
import CoreCommonKit
import CoreUIKit
import Combine

struct FilterChipComponent: Component {
    var identifier: String
    let item: FilterChipModel
    
    init(identifier: String, item: FilterChipModel) {
        self.identifier = identifier
        self.item = item
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(item)
    }
}

extension FilterChipComponent {
    typealias ContentType = FilterChipView
    
    func render(content: ContentType, context: Self, cancellable: inout Set<AnyCancellable>) {
        content.configure(
            title: context.item.title,
            isSelected: context.item.isSelected
        )
    }
}

final class FilterChipView: BaseView {
    let container = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillProportionally
        $0.alignment = .center
        $0.spacing = 8
    }
    
    let selectedImageView = UIImageView().then {
        $0.backgroundColor = .cyan
        $0.layer.cornerRadius = 28 / 2
    }
    let titleLabel = UILabel()
    
    let blueGradientView = PurithmGradientView().then {
        $0.colorType = .blue(direction: .trailing)
        $0.layer.cornerRadius = 18
        $0.clipsToBounds = true
    }
    
    override func setupSubviews() {
        self.layer.cornerRadius = 18
        self.clipsToBounds = true
        
        [blueGradientView, container].forEach {
            addSubview($0)
        }
        
        [selectedImageView, titleLabel].forEach {
            container.addArrangedSubview($0)
        }
    }
    
    override func setupConstraints() {
        container.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.leading.equalToSuperview().inset(4)
            make.trailing.equalToSuperview().inset(12)
        }
        
        selectedImageView.snp.makeConstraints { make in
            make.size.equalTo(28)
        }
        
        blueGradientView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        self.snp.makeConstraints { make in
            make.height.equalTo(36)
        }
    }
    
    func configure(title: String, isSelected: Bool) {
        let typo = isSelected ? Constants.selectedTitleTypo : Constants.normalTitleTypo
        
        titleLabel.applyTypography(with: typo)
        titleLabel.text = title
        
        selectedImageView.isHidden = !isSelected
        blueGradientView.isHidden = !isSelected
        
        container.snp.updateConstraints { make in
            make.leading.equalToSuperview().inset(isSelected ? 4 : 12)
        }
    }
}

extension FilterChipView {
    private enum Constants {
        static let normalTitleTypo = Typography(size: .size16, weight: .semibold, alignment: .center, color: .gray400, applyLineHeight: true)
        static let selectedTitleTypo = Typography(size: .size16, weight: .semibold, alignment: .center, color: .white, applyLineHeight: true)
    }
}
