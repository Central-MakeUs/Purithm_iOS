//
//  FilterDescriptionItemView.swift
//  Filter
//
//  Created by 이숭인 on 8/4/24.
//

import UIKit
import CoreUIKit
import SnapKit
import Then
import Kingfisher

extension FilterDescriptionItemView {
    private enum Constants {
        static let headerTitleTypo = Typography(size: .size36, weight: .medium, color: .gray500, applyLineHeight: true)
        static let headerSubTitleTypo = Typography(size: .size21, weight: .medium , color: .blue400, applyLineHeight: true)
        
        static let titleTypo = Typography(size: .size20, weight: .medium , color: .gray500, applyLineHeight: true)
        static let descriptionTypo = Typography(size: .size16, weight: .medium , color: .gray500, applyLineHeight: true)
        
    }
}

final class FilterDescriptionItemView: BaseView {
    let imageView = UIImageView().then {
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFill
    }
    private var imageSize: CGSize?
    
    private let contentContainer = UIStackView().then {
        $0.axis = .vertical
        $0.isLayoutMarginsRelativeArrangement = true
        $0.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        $0.distribution = .fillProportionally
        $0.spacing = 40
    }
    let headerContainer = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 0
        $0.distribution = .fill
    }
    let headerLabel = PurithmLabel(typography: Constants.headerTitleTypo)
    let headerSubTitleContainer = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillProportionally
        $0.spacing = 5
    }
    let subTitleImage = UIImageView().then {
        $0.image = .icHome.withTintColor(.blue400)
    }
    let headerSubTitleLabel = PurithmLabel(typography: Constants.headerSubTitleTypo)
    
    let descriptionContainer = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fillProportionally
        $0.spacing = 20
    }
    let titleLabel = PurithmLabel(typography: Constants.titleTypo)
    let descriptionLabel = PurithmLabel(typography: Constants.descriptionTypo).then {
        $0.numberOfLines = 0
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        updateImageViewHeight()
    }
    
    override func setup() {
        super.setup()
    }
    
    override func setupSubviews() {
        self.backgroundColor = .gray100
        
        addSubview(imageView)
        addSubview(contentContainer)
        
        contentContainer.addArrangedSubview(headerContainer)
        contentContainer.addArrangedSubview(descriptionContainer)
        
        headerContainer.addArrangedSubview(headerLabel)
        headerContainer.addArrangedSubview(headerSubTitleContainer)
        headerSubTitleContainer.addArrangedSubview(subTitleImage)
        headerSubTitleContainer.addArrangedSubview(headerSubTitleLabel)
        
        descriptionContainer.addArrangedSubview(titleLabel)
        descriptionContainer.addArrangedSubview(descriptionLabel)
    }
    
    override func setupConstraints() {
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(self.snp.width)
        }
        
        contentContainer.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(40)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
 
        subTitleImage.snp.makeConstraints { make in
            make.size.equalTo(20)
        }
    }
    
    func configure(with model: FilterDescriptionModel) {
        if let url = URL(string: model.contentImageURLString) {
            imageView.kf.setImage(with: url) { [weak self] response in
                switch response {
                case .success(let success):
                    self?.imageSize = success.image.size
                    self?.setNeedsUpdateConstraints()
                case .failure:
                    break
                }
            }
        }
        
        if model.type == .content {
            headerContainer.isHidden = true
        }
        
        headerLabel.text = "from.\(model.headerTitle ?? "")"
        headerSubTitleLabel.text = "Go to shop"
        
        titleLabel.text = model.contentTitle
        descriptionLabel.text = model.contentDescription
    }
    
    private func updateImageViewHeight() {
        guard let imageSize = imageSize else { return }
        
        // 이미지뷰의 너비 가져오기
        let imageViewWidth = imageView.frame.width
        
        // 이미지의 비율을 유지하면서 이미지뷰의 높이 계산
        let aspectRatio = imageSize.height / imageSize.width
        let imageViewHeight = imageViewWidth * aspectRatio
        
        imageView.snp.remakeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(imageViewHeight)
        }
    }
}
