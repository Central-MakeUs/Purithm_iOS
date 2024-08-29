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
import CombineCocoa
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
        let sliderValue = content.sliderView.controlEventPublisher(for: .valueChanged)
            .map { Int(content.sliderView.value) }
            .map { value -> Int in
                switch value {
                case 0...19:
                    return 0
                case 20...39:
                    return 20
                case 40...59:
                    return 40
                case 60...79:
                    return 60
                case 80...99:
                    return 80
                case 100:
                    return 100
                default:
                    return 0
                }
            }
            .removeDuplicates(by: { $0 == $1 })
        
        sliderValue
            .sink { [weak content] value in
                let calculatedValue = SatisfactionLevel.calculateSatisfactionLevel(with: Int(value)).rawValue
                
                content?.actionEventEmitter.send(ReviewSliderAction(
                    identifier: context.identifier,
                    intensity: CGFloat(calculatedValue)
                ))
            }
            .store(in: &cancellable)
        
        content.sliderView.controlEventPublisher(for: [.touchUpInside, .touchUpOutside])
            .map { content.sliderView.value }
            .sink { [weak content] value in
                let calculatedValue = SatisfactionLevel.calculateSatisfactionLevel(with: Int(value)).rawValue
                
                content?.sliderView.setValue(Float(calculatedValue), animated: true)
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
//        $0.isContinuous = false
        $0.setThumbImage(.bubble, for: .normal)
    }
    
    let textContainer = UIView().then {
        $0.backgroundColor = .gray100
    }
    
    let unfortunateLabel = PurithmLabel(typography: Constants.unfortunateTypo).then {
        $0.text = "아쉬워요"
    }
    let satisfiedLabel = PurithmLabel(typography: Constants.satisfiedTypo).then {
        $0.text = "만족해요"
    }
    
    override func setup() {
        super.setup()
        
        self.backgroundColor = .gray100
    }
    
    override func setupSubviews() {
        addSubview(container)
        
        container.addSubview(sliderView)
        container.addSubview(textContainer)
        
        textContainer.addSubview(unfortunateLabel)
        textContainer.addSubview(satisfiedLabel)
    }
    
    override func setupConstraints() {
        container.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(20)
        }
        
        sliderView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(textContainer.snp.top)
            make.height.equalTo(32)
        }
        
        textContainer.snp.makeConstraints { make in
            make.top.equalTo(sliderView.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        unfortunateLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.verticalEdges.equalToSuperview()
        }
        
        satisfiedLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.verticalEdges.equalToSuperview()
        }
    }
}

extension ReviewSliderView {
    private enum Constants {
        static let unfortunateTypo = Typography(size: .size14, weight: .medium, color: .gray300, applyLineHeight: true)
        static let satisfiedTypo = Typography(size: .size14, weight: .medium, color: .blue400, applyLineHeight: true)
        
    }
}
//
//sliderValue
//    .sink { [weak content] value in
//        content?.actionEventEmitter.send(ReviewSliderAction(
//            identifier: context.identifier,
//            intensity: CGFloat(value)
//        ))
//    }
//    .store(in: &cancellable)
