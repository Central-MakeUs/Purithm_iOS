//
//  FilterDescriptionHeader.swift
//  Filter
//
//  Created by 이숭인 on 8/18/24.
//

import UIKit
import CoreUIKit
import CoreCommonKit
import SnapKit
import Then

final class FilterDescriptionHeader: BaseView {
    let profileView = PurithmHorizontalProfileView()
    let descriptionLabel = PurithmLabel(typography: Constants.descriptionTypo).then {
        $0.numberOfLines = 0
    }
    
    override func setup() {
        super.setup()
        
        self.backgroundColor = .gray100
    }
    
    override func setupSubviews() {
        addSubview(profileView)
        addSubview(descriptionLabel)
    }
    
    override func setupConstraints() {
        profileView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(profileView.snp.bottom).offset(40)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    func configure(with descriptionModel: FilterDescriptionModel) {
        let profileModel = PurithmHorizontalProfileModel(
            type: .artist,
            satisfactionLevel: nil,
            name: descriptionModel.authorName,
            profileURLString: descriptionModel.authorProfileImageURLString
        )
        
        profileView.configure(with: profileModel)
        descriptionLabel.text = descriptionModel.authorDescription
    }
}

extension FilterDescriptionHeader {
    private enum Constants {
        static let descriptionTypo = Typography(size: .size16, weight: .medium, color: .gray500, applyLineHeight: true)
    }
}
