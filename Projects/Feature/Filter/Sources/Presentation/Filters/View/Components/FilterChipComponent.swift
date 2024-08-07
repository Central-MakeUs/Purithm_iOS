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
    let titleLabel = UILabel()
    
    let blueGradientView = PurithmGradientView().then {
        $0.colorType = .blue(direction: .trailing)
        $0.layer.cornerRadius = 18
        $0.clipsToBounds = true
    }
    
    override func setupSubviews() {
        self.layer.cornerRadius = 18
        self.clipsToBounds = true
        
        [blueGradientView, titleLabel].forEach {
            addSubview($0)
        }
    }
    
    override func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(12)
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
        
        blueGradientView.isHidden = !isSelected
    }
}

extension FilterChipView {
    private enum Constants {
        static let normalTitleTypo = Typography(size: .size16, weight: .semibold, alignment: .center, color: .gray400, applyLineHeight: true)
        static let selectedTitleTypo = Typography(size: .size16, weight: .semibold, alignment: .center, color: .white, applyLineHeight: true)
    }
}
