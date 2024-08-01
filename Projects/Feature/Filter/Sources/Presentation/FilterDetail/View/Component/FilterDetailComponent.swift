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
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(imageURLString)
    }
}

extension FilterDetailComponent {
    typealias ContentType = FilterDetailComponentView
    
    func render(content: ContentType, context: Self, cancellable: inout Set<AnyCancellable>) {
        content.configure(with: context.imageURLString)
    }
}

final class FilterDetailComponentView: BaseView {
    let imageView = UIImageView()
    
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
            imageView.kf.setImage(with: url) { result in
                //TODO: 인디케이터? 아니면 place holder 이미지 추가하자.
            }
        }
    }
}

