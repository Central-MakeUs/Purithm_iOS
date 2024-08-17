//
//  FilterOptionDetailView.swift
//  Filter
//
//  Created by 이숭인 on 8/6/24.
//

import UIKit
import CoreUIKit
import CoreCommonKit
import Combine

final class FilterOptionDetailView: BaseView {
    //MARK: UI Components
    let topContainer = UIView()
    let headerView = PurithmHeaderView()
    
    private let helpOptionTapGesture = UITapGestureRecognizer()
    let optionContainer = UIView().then {
        $0.layer.cornerRadius = 32 / 2
        $0.backgroundColor = .blue300
    }
    let optionLabel = PurithmLabel(typography: Constants.optionLabelTypo).then {
        $0.text = "아이폰에서 필터 적용하는 법"
    }
    let rightImageView = UIImageView().then {
        $0.image = .icArrowRight.withTintColor(.white)
    }
    
    let bottomContainer = UIView()
    let contentImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.kf.indicatorType = .activity
    }
    let gradientView = PurithmGradientView().then {
        $0.colorType = .purple(direction: .trailing)
    }
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        $0.backgroundColor = .clear
    }
    
    //MARK: Properties
    var backButtonTapEvent: AnyPublisher<Void, Never> {
        headerView.leftButton.tap
    }
    
    var likeButtonTapEvent: AnyPublisher<Void, Never> {
        headerView.likeButton.tap
    }
    
    var helpOptionTapEvent: AnyPublisher<Void, Never> {
        helpOptionTapGesture.tapPublisher.mapToVoid().eraseToAnyPublisher()
    }
    
    //MARK: Life Cycle
    override func setup() {
        super.setup()
        self.backgroundColor = .gray100
        
        optionContainer.addGestureRecognizer(helpOptionTapGesture)
    }
    
    override func setupSubviews() {
        addSubview(topContainer)
        addSubview(bottomContainer)
        
        [headerView, optionContainer].forEach {
            topContainer.addSubview($0)
        }
        
        optionContainer.addSubview(optionLabel)
        optionContainer.addSubview(rightImageView)
        
        bottomContainer.addSubview(contentImageView)
        bottomContainer.addSubview(gradientView)
        bottomContainer.addSubview(collectionView)
    }
    
    override func setupConstraints() {
        topContainer.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
        }
        
        headerView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }
        
        optionContainer.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(4)
            make.leading.equalToSuperview().inset(20)
            make.trailing.lessThanOrEqualToSuperview()
            make.bottom.equalToSuperview().inset(20)
        }
        
        optionLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(12)
            make.verticalEdges.equalToSuperview().inset(8)
        }
        
        rightImageView.snp.makeConstraints { make in
            make.leading.equalTo(optionLabel.snp.trailing).offset(6)
            make.verticalEdges.equalToSuperview().inset(8)
            make.trailing.equalToSuperview().inset(12)
            make.size.equalTo(16)
        }
        
        bottomContainer.snp.makeConstraints { make in
            make.top.equalTo(topContainer.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        contentImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        gradientView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.lessThanOrEqualToSuperview()
            make.width.equalTo(self.snp.width).multipliedBy(0.75)
        }
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configure(with headerType: PurithmHeaderType, imageURLString: String) {
        headerView.configure(with: headerType)
        
        if let url = URL(string: imageURLString) {
            contentImageView.kf.setImage(with: url, placeholder: UIImage.placeholderSquareXl)
        }
    }
}

extension FilterOptionDetailView {
    private enum Constants {
        static let optionLabelTypo = Typography(size: .size14, weight: .semibold, color: .white, applyLineHeight: true)
    }
}
