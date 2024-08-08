//
//  ArtistProfileComponent.swift
//  Author
//
//  Created by 이숭인 on 8/9/24.
//

import UIKit
import CoreUIKit
import CoreCommonKit
import Combine

struct ArtistProfileComponentComponent: Component {
    var identifier: String
    let profileModel: PurithmVerticalProfileModel
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(profileModel.name)
        hasher.combine(profileModel.introduction)
        hasher.combine(profileModel.profileURLString)
        hasher.combine(profileModel.type)
    }
}

extension ArtistProfileComponentComponent {
    typealias ContentType = ArtistProfileComponentView
    
    func render(content: ContentType, context: Self, cancellable: inout Set<AnyCancellable>) {
        content.configure(with: context.profileModel)
    }
}

final class ArtistProfileComponentView: BaseView {
    let profileView = PurithmVerticalProfileView()
    
    override func setupSubviews() {
        addSubview(profileView)
    }
    
    override func setupConstraints() {
        profileView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configure(with profileModel: PurithmVerticalProfileModel) {
        profileView.configure(with: profileModel)
    }
}

