//
//  ReviewUploadImageContainerHeaderComponent.swift
//  Review
//
//  Created by 이숭인 on 8/18/24.
//

import UIKit
import CoreUIKit
import CoreCommonKit
import Combine

struct ReviewUploadImageContainerHeaderComponent: Component {
    var identifier: String
    
    func hash(into hasher: inout Hasher) {
        
    }
}

extension ReviewUploadImageContainerHeaderComponent {
    typealias ContentType = ReviewUploadImageContainerHeaderView
    
    func render(content: ContentType, context: Self, cancellable: inout Set<AnyCancellable>) {
        
    }
}

final class ReviewUploadImageContainerHeaderView: BaseView {
    let descriptionLabel = PurithmLabel(typography: Constants.descriptionTypo).then {
        $0.text = "(필수) 사진 1장 이상"
    }
    
    override func setup() {
        super.setup()
        
        self.backgroundColor = .gray100
    }
    
    override func setupSubviews() {
        addSubview(descriptionLabel)
    }
    
    override func setupConstraints() {
        descriptionLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(22)
        }
    }
}

extension ReviewUploadImageContainerHeaderView {
    private enum Constants {
        static let descriptionTypo = Typography(size: .size14, weight: .medium, color: .gray300, applyLineHeight: true)
    }
}
        
