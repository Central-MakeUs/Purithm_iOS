//
//  ProfileEditImageComponent.swift
//  Profile
//
//  Created by 이숭인 on 8/22/24.
//

import Foundation

import UIKit
import CoreUIKit
import CoreCommonKit
import Combine

struct ProfileEditImageAction: ActionEventItem { }

struct ProfileEditImageComponent: Component {
    var identifier: String
    let thumbnailURLString: String
    let isUploadState: Bool
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(thumbnailURLString)
        hasher.combine(isUploadState)
    }
}

extension ProfileEditImageComponent {
    typealias ContentType = ProfileEditImageView
    
    func render(content: ContentType, context: Self, cancellable: inout Set<AnyCancellable>) {
        content.configure(
            thumbnail: context.thumbnailURLString,
            isUploadState: context.isUploadState
        )
        
        content.imageTapGesture.tapPublisher
            .sink { [weak content] _  in
                content?.actionEventEmitter.send(ProfileEditImageAction())
            }
            .store(in: &cancellable)
    }
}

final class ProfileEditImageView: BaseView, ActionEventEmitable {
    var actionEventEmitter = PassthroughSubject<ActionEventItem, Never>()
    
    let backgroundContainer = UIView().then {
        $0.backgroundColor = .gray100
    }
    let profileContainer = UIView()
    let profileImageView = UIImageView().then {
        $0.layer.cornerRadius = 100 / 2
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFill
    }
    let cameraContainer = UIView().then {
        $0.backgroundColor = .blue400
        $0.layer.cornerRadius = 32 / 2
        $0.clipsToBounds = true
    }
    
    let uploadStateBackgroundView = UIView().then {
        $0.backgroundColor = .black040
        $0.isUserInteractionEnabled = false
    }
    let uploadIndicator = UIActivityIndicatorView(style: .medium).then {
        $0.color = .purple500
    }
    
    let cameraImageView = UIImageView().then {
        $0.image = .icCamera.withTintColor(.white)
        $0.backgroundColor = .blue400
        $0.isUserInteractionEnabled = false
    }
    
    let imageTapGesture = UITapGestureRecognizer()
    
    override func setup() {
        super.setup()
        
        cameraContainer.addGestureRecognizer(imageTapGesture)
    }
    
    override func setupSubviews() {
        addSubview(backgroundContainer)
        backgroundContainer.addSubview(profileContainer)
        
        profileContainer.addSubview(profileImageView)
        profileContainer.addSubview(cameraContainer)
        cameraContainer.addSubview(cameraImageView)
        
        profileImageView.addSubview(uploadStateBackgroundView)
        uploadStateBackgroundView.addSubview(uploadIndicator)
    }
    
    override func setupConstraints() {
        backgroundContainer.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        profileContainer.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(40)
            make.centerX.equalToSuperview()
            make.size.equalTo(100)
        }
        
        uploadStateBackgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        uploadIndicator.snp.makeConstraints { make in
            make.center.equalTo(uploadStateBackgroundView.snp.center)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        cameraContainer.snp.makeConstraints { make in
            make.size.equalTo(32)
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        cameraImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(18)
        }
    }
    
    func configure(thumbnail: String, isUploadState: Bool) {
        if let url = URL(string: thumbnail) {
            profileImageView.kf.setImage(
                with: url,
                placeholder: UIImage.placeholderSquareLg
            )
        } else {
            profileImageView.image = .emptyProfile
        }
        
        uploadStateBackgroundView.isHidden = !isUploadState
        isUploadState ? uploadIndicator.startAnimating() : uploadIndicator.stopAnimating()
    }
}

