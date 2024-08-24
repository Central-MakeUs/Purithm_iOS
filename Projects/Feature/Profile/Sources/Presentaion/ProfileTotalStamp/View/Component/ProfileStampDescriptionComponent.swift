//
//  ProfileStampDescriptionComponent.swift
//  Profile
//
//  Created by 이숭인 on 8/23/24.
//

import Foundation

import UIKit
import CoreUIKit
import CoreCommonKit
import Combine

struct ProfileMoveToAccessedFilterAction: ActionEventItem {
    
}

struct ProfileStampDescriptionComponent: Component {
    var identifier: String
    
    func hash(into hasher: inout Hasher) {
        
    }
}

extension ProfileStampDescriptionComponent {
    typealias ContentType = ProfileStampDescriptionView
    
    func render(content: ContentType, context: Self, cancellable: inout Set<AnyCancellable>) {
        content.tapGesture.tapPublisher
            .sink { [weak content] _ in
                content?.actionEventEmitter.send(ProfileMoveToAccessedFilterAction())
            }
            .store(in: &cancellable)
    }
}

final class ProfileStampDescriptionView: BaseView, ActionEventEmitable {
    var actionEventEmitter = PassthroughSubject<ActionEventItem, Never>()
    
    let tapGesture = UITapGestureRecognizer()
    let backgroundView = UIImageView().then {
        $0.image = .bgS
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
    }
    
    let descriptionLabel = PurithmLabel(typography: Constants.descriptionTypo).then {
        $0.text = "후기 남기고\n스탬프를 채워보세요 >"
        $0.numberOfLines = 0
        
    }
    let stampImageView = UIImageView().then {
        $0.image = .grFlower
    }
    
    override func setup() {
        super.setup()
        
        self.isUserInteractionEnabled = true
        self.layer.cornerRadius = 12
        self.clipsToBounds = true
        self.addGestureRecognizer(tapGesture)
    }
    
    override func setupSubviews() {
        addSubview(backgroundView)
        addSubview(descriptionLabel)
        addSubview(stampImageView)
    }
    
    override func setupConstraints() {
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.verticalEdges.lessThanOrEqualToSuperview().inset(30)
            make.leading.equalToSuperview().inset(30)
            make.trailing.equalTo(stampImageView.snp.leading).offset(-20)
        }
        
        stampImageView.snp.makeConstraints { make in
            make.size.equalTo(64)
            make.verticalEdges.equalToSuperview().inset(30)
            make.trailing.equalToSuperview().inset(30)
        }
    }
}

extension ProfileStampDescriptionView {
    private enum Constants {
        static let descriptionTypo = Typography(size: .size21, weight: .bold, color: .white, applyLineHeight: true)
    }
}
