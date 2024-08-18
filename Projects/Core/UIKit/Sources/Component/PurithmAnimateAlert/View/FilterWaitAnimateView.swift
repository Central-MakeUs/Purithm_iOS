//
//  FilterWaitAnimateView.swift
//  CoreUIKit
//
//  Created by 이숭인 on 8/17/24.
//

import UIKit
import Then
import CoreCommonKit
import SnapKit
import Kingfisher

public final class FilterWaitAnimateView: BaseView {
    let backgroundImageView = UIImageView().then {
        $0.image = .bgLg
    }
    
    let butterflyImageView = AnimatedImageView().then {
        $0.kf.indicatorType = .activity
        $0.contentMode = .scaleAspectFit
    }
    let whiteContainer = UIView().then {
        $0.layer.cornerRadius = 12
        $0.backgroundColor = .white020
    }
    let titleLabel = PurithmLabel(typography: Constants.titleTypo).then {
        $0.text = "We are preparing..."
    }
    let filterNameLabel = PurithmLabel(typography: Constants.filterNameTypo).then {
        $0.text = "Dreamlike" // 필터 이름인듯
    }
    
    public override func setup() {
        super.setup()
        
        titleLabel.font = UIFont.EBGaramond.semiBold.font(size: 18)
        fetchGIF()
    }
    
    public override func setupSubviews() {
        addSubview(backgroundImageView)
        addSubview(whiteContainer)
        addSubview(butterflyImageView)
        
        whiteContainer.addSubview(titleLabel)
        whiteContainer.addSubview(filterNameLabel)
    }
    
    public override func setupConstraints() {
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        whiteContainer.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(60)
            make.height.equalTo(340)
        }
        
        butterflyImageView.snp.makeConstraints { make in
            make.centerY.equalTo(whiteContainer.snp.top)
            make.centerX.equalToSuperview()
            make.size.equalTo(180)
        }
        
        filterNameLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(8)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.bottom.equalTo(filterNameLabel.snp.top).offset(-6)
            make.horizontalEdges.equalToSuperview().inset(8)
            make.centerX.equalToSuperview()
        }
    }
    
    public func configure(with filterName: String) {
        filterNameLabel.text = filterName
        filterNameLabel.font = UIFont.EBGaramond.semiBold.font(size: 36)
    }
    
    private func fetchGIF() {
        if let url = URL(string: "https://purithm.s3.ap-northeast-2.amazonaws.com/purithm+splash.gif") {
            butterflyImageView.kf.setImage(
                with: url,
                options: [
                    .cacheOriginalImage,
                ]
            )
        }
    }
}

extension FilterWaitAnimateView {
    private enum Constants {
        static let titleTypo = Typography(size: .size18, weight: .semibold, alignment: .center, color: .blue400, applyLineHeight: true)
        static let filterNameTypo = Typography(size: .size36, weight: .medium, alignment: .center, color: .blue400, applyLineHeight: true)
    }
}
