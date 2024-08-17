//
//  FilterDetailComponent.swift
//  Filter
//
//  Created by 이숭인 on 7/31/24.
//

import UIKit
import CoreUIKit
import CoreCommonKit
import Combine
import Kingfisher
import SnapKit

struct FilterDetailComponent: Component {
    var identifier: String
    let imageURLString: String
    let originalImageURLString: String
    let showOriginal: Bool
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(imageURLString)
        hasher.combine(originalImageURLString)
        hasher.combine(showOriginal)
    }
}

extension FilterDetailComponent {
    typealias ContentType = FilterDetailComponentView
    
    func render(content: ContentType, context: Self, cancellable: inout Set<AnyCancellable>) {
        content.configure(with: context.showOriginal ? context.originalImageURLString : context.imageURLString)
    }
}

final class FilterDetailComponentView: BaseView {
    let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.kf.indicatorType = .activity
    }
    
    override func setupSubviews() {
        addSubview(imageView)
    }
    
    deinit {
        print("FilterDetailComponent deinit")
    }
    
    override func setupConstraints() {
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configure(with imageURLString: String) {
        if let url = URL(string: imageURLString) {
            imageView.kf.setImage(with: url, placeholder: UIImage.placeholderSquareXl)
        }
    }
}

