//
//  ReviewSliderComponent.swift
//  Review
//
//  Created by 이숭인 on 8/9/24.
//

import UIKit
import CoreUIKit
import CoreCommonKit
import Combine
import RxSwift

struct ReviewSliderAction: ActionEventItem {
    let identifier: String
    let intensity: CGFloat
}

struct ReviewSliderComponent: Component {
    var identifier: String
    
    func hash(into hasher: inout Hasher) {
        
    }
}

extension ReviewSliderComponent {
    typealias ContentType = ReviewSliderView
    
    func render(content: ContentType, context: Self, cancellable: inout Set<AnyCancellable>) {
        content.sliderView.valuePublisher
            .map { value -> CGFloat in
                let step: Float = 20
                return CGFloat(round(value / step) * step)
            }
            .sink { [weak content] value in
                print("::: value > \(value)")
                guard let content else { return }
                content.sliderView.setValue(Float(value), animated: true)
                
                content.actionEventEmitter.send(ReviewSliderAction(
                    identifier: context.identifier,
                    intensity: value
                ))
            }
            .store(in: &cancellable)
    }
}

final class ReviewSliderView: BaseView, ActionEventEmitable {
    var actionEventEmitter = PassthroughSubject<ActionEventItem, Never>()
    
    let container = UIView()
    let sliderView = UISlider().then {
        $0.minimumValue = 0
        $0.maximumValue = 100
        $0.minimumTrackTintColor = .white
        $0.maximumTrackTintColor = .white
        $0.isContinuous = false
        $0.setThumbImage(.bubble, for: .normal)
    }
    
    override func setup() {
        super.setup()
        
        self.backgroundColor = .gray100
    }
    
    override func setupSubviews() {
        addSubview(container)
        
        container.addSubview(sliderView)
    }
    
    override func setupConstraints() {
        container.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(20)
        }
        
        sliderView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(32)
        }
        
//        thumbView.snp.makeConstraints { make in
//            make.height.equalTo(32)
//        }
//        
//        thumbImageView.snp.makeConstraints { make in
//            make.size.equalTo(20)
//            make.center.equalToSuperview()
//        }
    }
}

