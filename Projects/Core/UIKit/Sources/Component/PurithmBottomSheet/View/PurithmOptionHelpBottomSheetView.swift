//
//  PurithmScrollableBottomSheetView.swift
//  CoreUIKit
//
//  Created by 이숭인 on 8/7/24.
//

import UIKit
import CoreCommonKit
import SnapKit
import Then
import Combine

public final class PurithmOptionHelpBottomSheetView: BaseView {
    private let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
    }
    
    let topGradientView = PurithmGradientView().then {
        $0.colorType = .white(direction: .bottom)
    }
    let bottomGradientView = PurithmGradientView().then {
        $0.colorType = .white(direction: .top)
    }
    
    private let container = UIView()
    let titleLabel = PurithmLabel(typography: Constants.titleTypo).then {
        $0.text = "보정값은 어떻게 적용하나요?"
    }
    
    let helpOptionContainer = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fill
        $0.alignment = .fill
        $0.spacing = 20
    }
    
    let helpOptionViews: [OptionHelpBottomSheetContentView] = PurithmOptionHelpContentType.allCases.map {
        let optionView = OptionHelpBottomSheetContentView()
        optionView.configure(with: $0)
        optionView.layer.cornerRadius = 12
        optionView.clipsToBounds = true
        return optionView
    }
    
    let conformButton = PlainButton(type: .filled, variant: .default, size: .large).then {
        $0.text = "확인"
    }
    
    public var conformTapEvent: AnyPublisher<Void, Never> {
        conformButton.tap
    }
    
    public override func setup() {
        super.setup()
        
        self.backgroundColor = .gray100
    }
    
    public override func setupSubviews() {
        addSubview(scrollView)
        addSubview(conformButton)
        
        scrollView.addSubview(container)
        
        container.addSubview(titleLabel)
        container.addSubview(helpOptionContainer)
        
        helpOptionViews.forEach {
            helpOptionContainer.addArrangedSubview($0)
        }
        
        //gradient
        addSubview(bottomGradientView)
        addSubview(topGradientView)
    }
    
    public override func setupConstraints() {
        topGradientView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(30)
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(conformButton.snp.top).offset(-20)
        }
        
        conformButton.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalTo(safeAreaLayoutGuide)
        }
        
        bottomGradientView.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(conformButton.snp.top).offset(-20)
        }
        
        container.snp.makeConstraints { make in
            make.width.equalTo(scrollView)
            make.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(30)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        helpOptionContainer.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(30)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.lessThanOrEqualToSuperview()
        }
    }
}

extension PurithmOptionHelpBottomSheetView {
    private enum Constants {
        static let titleTypo = Typography(size: .size24, weight: .bold, color: .gray500, applyLineHeight: true)
    }
}
