//
//  ProfileUserProfileComponent.swift
//  Profile
//
//  Created by 이숭인 on 8/21/24.
//

import Foundation

import UIKit
import CoreUIKit
import CoreCommonKit
import Combine

struct ProfileUserEditAction: ActionEventItem {
    
}

struct ProfileUserProfileComponent: Component {
    var identifier: String
    let profileModel: PurithmVerticalProfileModel
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(profileModel.name)
        hasher.combine(profileModel.introduction)
        hasher.combine(profileModel.profileURLString)
        hasher.combine(profileModel.type)
    }
}

extension ProfileUserProfileComponent {
    typealias ContentType = ProfileUserProfileView
    
    func render(content: ContentType, context: Self, cancellable: inout Set<AnyCancellable>) {
        content.configure(with: context.profileModel)
        
        content.profileView.editTapGesture.tapPublisher
            .sink { [weak content] _ in
                content?.actionEventEmitter.send(ProfileUserEditAction())
            }
            .store(in: &cancellable)
    }
}

final class ProfileUserProfileView: BaseView, ActionEventEmitable {
    var actionEventEmitter = PassthroughSubject<ActionEventItem, Never>()
    
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

