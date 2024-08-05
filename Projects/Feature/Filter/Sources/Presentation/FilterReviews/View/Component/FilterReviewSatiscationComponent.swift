//
//  FilterReviewSatiscationComponent.swift
//  Filter
//
//  Created by 이숭인 on 8/5/24.
//

import UIKit
import CoreUIKit
import Combine

struct FilterReviewSatiscationComponent: Component {
    var identifier: String
    let satisfactionLevel: SatisfactionLevel
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(satisfactionLevel)
    }
}

extension FilterReviewSatiscationComponent {
    typealias ContentType = FilterReviewSatiscationView
    
    func render(content: ContentType, context: Self, cancellable: inout Set<AnyCancellable>) {
        content.configure(with: context.satisfactionLevel)
    }
}

final class FilterReviewSatiscationView: BaseView {
    let container = UIView().then {
        $0.layer.cornerRadius = 140 / 2
        $0.clipsToBounds = true
    }
    let backgroundView = UIImageView()
    let titleLabel = PurithmLabel(typography: Constants.titleTypo).then {
        $0.text = "필터 만족도"
    }
    let satisfactionLabel = PurithmLabel(typography: Constants.satisfactionTypo)
    
    override func setup() {
        super.setup()
        
        self.backgroundColor = .gray100
    }
    
    override func setupSubviews() {
        addSubview(container)
        
        [backgroundView, titleLabel, satisfactionLabel].forEach {
            container.addSubview($0)
        }
    }
    
    override func setupConstraints() {
        self.snp.makeConstraints { make in
            make.height.equalTo(200)
        }
        
        container.snp.makeConstraints { make in
            make.size.greaterThanOrEqualTo(140)
            make.center.equalToSuperview()
        }
        
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(satisfactionLabel.snp.top)
        }
        
        satisfactionLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(38)
            make.horizontalEdges.equalToSuperview()
        }
    }
    
    func configure(with level: SatisfactionLevel) {
        satisfactionLabel.text = "\(level.rawValue) %"
        backgroundView.image = level.circleBackgroundImage
    }
}

extension FilterReviewSatiscationView {
    private enum Constants {
        static let titleTypo = Typography(size: .size14, weight: .semibold, alignment: .center, color: .white, applyLineHeight: true)
        static let satisfactionTypo = Typography(size: .size36, weight: .medium, alignment: .center, color: .white, applyLineHeight: true)
    }
}