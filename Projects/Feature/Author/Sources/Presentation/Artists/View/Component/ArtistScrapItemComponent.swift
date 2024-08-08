//
//  ArtistScrapItemComponent.swift
//  Author
//
//  Created by 이숭인 on 8/8/24.
//

import UIKit
import CoreUIKit
import CoreCommonKit
import Combine
import Kingfisher

struct ArtistScrapItemAction: ActionEventItem {
    let identifier: String
}

struct ArtistScrapItemComponentComponent: Component {
    var identifier: String
    let scrapModel: ArtistScrapModel
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(scrapModel.imageURLStrings)
        hasher.combine(scrapModel.artist)
        hasher.combine(scrapModel.artistProfileURLString)
        hasher.combine(scrapModel.content)
    }
    
    func prepareForReuse(content: ArtistScrapItemComponentView) {
        content.imageTopContainer.arrangedSubviews.forEach { subview in
            content.imageTopContainer.removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }
        content.imageBottomContainer.arrangedSubviews.forEach { subview in
            content.imageBottomContainer.removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }
    }
}

extension ArtistScrapItemComponentComponent {
    typealias ContentType = ArtistScrapItemComponentView
    
    func render(content: ContentType, context: Self, cancellable: inout Set<AnyCancellable>) {
        content.configure(with: context.scrapModel)
        
        content.imageContainerTapGesture.tapPublisher
            .sink { [weak content] _ in
                content?.actionEventEmitter.send(ArtistScrapItemAction(identifier: context.identifier))
            }
            .store(in: &cancellable)
        
        content.profileTapGesture.tapPublisher
            .sink { [weak content] _ in
                content?.actionEventEmitter.send(ArtistScrapItemAction(identifier: context.identifier))
            }
            .store(in: &cancellable)
    }
}

final class ArtistScrapItemComponentView: BaseView, ActionEventEmitable {
    var actionEventEmitter = PassthroughSubject<ActionEventItem, Never>()
    
    let container = UIView()
    
    let imageContainer = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fillEqually
        $0.alignment = .fill
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
        $0.spacing = 2
    }
    
    let imageTopContainer = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.alignment = .fill
        $0.spacing = 2
    }
    
    let imageBottomContainer = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fill
        $0.alignment = .fill
    }
    
    let profileView = PurithmProfileView()
    let contentLabel = PurithmLabel(typography: Constants.contentTypo)
    
    let imageContainerTapGesture = UITapGestureRecognizer()
    let profileTapGesture = UITapGestureRecognizer()
    
    override func setup() {
        super.setup()
        self.backgroundColor = .gray100
        
        imageContainer.addGestureRecognizer(imageContainerTapGesture)
        profileView.addGestureRecognizer(profileTapGesture)
    }
    
    override func setupSubviews() {
        addSubview(container)
        
        container.addSubview(imageContainer)
        container.addSubview(profileView)
        container.addSubview(contentLabel)
        
        imageContainer.addArrangedSubview(imageTopContainer)
        imageContainer.addArrangedSubview(imageBottomContainer)
    }
    
    override func setupConstraints() {
        container.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        imageContainer.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(self.snp.width).multipliedBy(1.25)
        }
        
        profileView.snp.makeConstraints { make in
            make.top.equalTo(imageContainer.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview()
        }
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(profileView.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    func configure(with artist: ArtistScrapModel) {
        setupImageContainer(with: artist.scripImageType, imageURLStrings: artist.imageURLStrings)
        contentLabel.text = artist.content
        
        profileView.configure(with: PurithmProfileModel(
            type: .artist,
            satisfactionLevel: nil,
            name: artist.artist,
            profileURLString: artist.artistProfileURLString
        ))
    }
    
    private func setupImageContainer(with type: ArtistScrapModel.ScrapImageType, imageURLStrings: [String]) {
        let imageViews = imageURLStrings.map { urlString in
            let imageView = UIImageView()
            imageView.backgroundColor = .systemGray
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            if let url = URL(string: urlString) {
                imageView.kf.setImage(with: url)
            }
            return imageView
        }
        
        switch type {
        case .single:
            guard imageViews[safe: 0] != nil else { break }
            imageTopContainer.isHidden = true
            imageBottomContainer.addArrangedSubview(imageViews[0])
        case .double:
            guard imageViews[safe: 0] != nil,
                  imageViews[safe: 1] != nil else { break }
            
            imageTopContainer.isHidden = false
            imageTopContainer.addArrangedSubview(imageViews[0])
            imageBottomContainer.addArrangedSubview(imageViews[1])
        case .thriple:
            guard imageViews[safe: 0] != nil,
                  imageViews[safe: 1] != nil,
                  imageViews[safe: 2] != nil else { break }
            
            imageTopContainer.isHidden = false
            imageTopContainer.addArrangedSubview(imageViews[0])
            imageTopContainer.addArrangedSubview(imageViews[1])
            imageBottomContainer.addArrangedSubview(imageViews[2])
        }
    }
}

extension ArtistScrapItemComponentView {
    private enum Constants {
        static let contentTypo = Typography(size: .size16, weight: .medium, color: .gray500, applyLineHeight: true)
    }
}
