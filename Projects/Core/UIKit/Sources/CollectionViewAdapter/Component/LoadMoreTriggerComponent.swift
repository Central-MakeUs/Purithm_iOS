//
//  LoadMoreTriggerComponent.swift
//  CoreUIKit
//
//  Created by 이숭인 on 8/18/24.
//

import UIKit
import CoreCommonKit
import Combine
import SnapKit
import Then

public struct LoadMoreTriggerComponent: Component {
    public var identifier: String
    let isLast: Bool
    
    public init(identifier: String, isLast: Bool) {
        self.identifier = identifier
        self.isLast = isLast
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(isLast)
    }
    
    public func prepareForReuse(content: LoadMoreTriggerView) {
        content.activityIndicator.startAnimating()
    }
}

extension LoadMoreTriggerComponent {
    public typealias ContentType = LoadMoreTriggerView
    
    public func render(content: ContentType, context: Self, cancellable: inout Set<AnyCancellable>) {
        content.configure(isLast: context.isLast)
    }
}

public final class LoadMoreTriggerView: BaseView {
    let emptySpace = UIView()
    let activityIndicator = UIActivityIndicatorView(style: .medium).then {
        $0.color = .purple500
    }
    let descriptionLabel = PurithmLabel(typography: Constants.descriptionTypo).then {
        $0.text = "마지막 페이지입니다."
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        activityIndicator.center = self.center
    }
    
    public override func setup() {
        super.setup()
        
        self.backgroundColor = .gray100
    }
    
    public override func setupSubviews() {
        addSubview(emptySpace)
        addSubview(activityIndicator)
        
        emptySpace.addSubview(descriptionLabel)
    }
    
    public override func setupConstraints() {
        emptySpace.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(60)
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(20)
        }
    }
    
    func configure(isLast: Bool) {
        if isLast {
            activityIndicator.isHidden = true
            activityIndicator.stopAnimating()
            descriptionLabel.isHidden = false
        } else {
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
            descriptionLabel.isHidden = true
        }
    }
}

extension LoadMoreTriggerView {
    private enum Constants {
        static let descriptionTypo = Typography(size: .size16, weight: .medium, alignment: .center, color: .gray300, applyLineHeight: true)
    }
}
