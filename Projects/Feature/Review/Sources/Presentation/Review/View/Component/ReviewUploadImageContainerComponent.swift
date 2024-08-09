//
//  ReviewUploadImageContainerComponent.swift
//  Review
//
//  Created by 이숭인 on 8/10/24.
//

import UIKit
import CoreUIKit
import CoreCommonKit
import Combine

struct ReviewUploadImageAction: ActionEventItem {
    let identifier: String
}

struct ReviewCancelUploadImageAction: ActionEventItem {
    let identifier: String
}

struct ReviewUploadImageContainerComponentModel {
    let identifier: String
    var selectedImage: UIImage?
}

struct ReviewUploadImageContainerComponent: Component {
    var identifier: String
    let model: ReviewUploadImageContainerComponentModel
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(model.selectedImage)
    }
}

extension ReviewUploadImageContainerComponent {
    typealias ContentType = ReviewUploadImageContainerView
    
    func render(content: ContentType, context: Self, cancellable: inout Set<AnyCancellable>) {
        content.containerTapGesture.tapPublisher
            .sink { [weak content] _ in
                content?.actionEventEmitter.send(ReviewUploadImageAction(identifier: context.identifier))
            }
            .store(in: &cancellable)
        
        content.cancelButton.tap
            .sink { [weak content] _ in
                content?.actionEventEmitter.send(ReviewCancelUploadImageAction(identifier: context.identifier))
            }
            .store(in: &cancellable)
        
        content.configure(with: context.model)
    }
}

final class ReviewUploadImageContainerView: BaseView, ActionEventEmitable {
    var actionEventEmitter = PassthroughSubject<ActionEventItem, Never>()
    
    let container = UIView().then {
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
    }
    let containerTapGesture = UITapGestureRecognizer()
    
    let imageView = UIImageView().then {
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFill
        $0.backgroundColor = .white
        $0.isUserInteractionEnabled = false
        $0.backgroundColor = .clear
    }
    
    let iconImageView = UIImageView().then {
        $0.image = .icCollector
    }
    
    let cancelButton = UIButton().then {
        $0.setImage(.icDeletePressed, for: .normal)
    }
    
    override func setup() {
        super.setup()
        self.layer.cornerRadius = 12
        self.clipsToBounds = true
        
        self.addGestureRecognizer(containerTapGesture)
    }
    
    override func setupSubviews() {
        addSubview(container)
        
        container.addSubview(iconImageView)
        container.addSubview(imageView)
        container.addSubview(cancelButton)
    }
    
    override func setupConstraints() {
        container.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(self.snp.width)
        }
        
        iconImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(24)
        }
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        cancelButton.snp.makeConstraints { make in
            make.size.equalTo(24)
            make.top.trailing.equalToSuperview().inset(5)
        }
    }
    
    func configure(with model: ReviewUploadImageContainerComponentModel) {
        guard let selectedImage = model.selectedImage else {
            cancelButton.isHidden = true
            imageView.image = nil
            return
        }
        
        imageView.image = selectedImage
        cancelButton.isHidden = false
    }
}

