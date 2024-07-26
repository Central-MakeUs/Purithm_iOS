//
//  PurithmCommonButton.swift
//  CoreUIKit
//
//  Created by 이숭인 on 7/25/24.
//

import UIKit
import Combine
import CombineCocoa

//MARK: Variant
extension PurithmCommonButton {
    public enum Variant {
        case `default`
        case primary
        case secondary
    }
}

//MARK: State
extension PurithmCommonButton {
    public enum State {
        case `default`
        case pressed
        case disabled
    }
}

//MARK: Size
extension PurithmCommonButton {
    public enum Size: CGFloat {
        case xlarge = 52
        case large = 44
        case medium = 40
        case small = 36
        case xsmall = 28
        
        /// Button 의 Conents와 버튼 사이의 Margin
        var layoutMargin: UIEdgeInsets {
            switch self {
            case .xlarge: return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
            case .large, .medium, .small: return UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
            case .xsmall: return UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
            }
        }
        
        var spacing: CGFloat {
            switch self {
            case .xlarge: return 8
            default: return 4
            }
        }
    }
}

public class PurithmCommonButton: UIControl {
    private var cancellables = Set<AnyCancellable>()
    
    var variant: Variant
    var size: Size
    
    private(set) var buttonState: State = .default {
        didSet { updateState() }
    }
    
    public override var isEnabled: Bool {
        get {
            super.isEnabled
        }
        set {
            buttonState = {
                if newValue {
                    return .default
                } else {
                    return .disabled
                }
            }()
            
            super.isEnabled = newValue
        }
    }
    
    public override var isSelected: Bool {
        get {
            super.isSelected
        }
        set {
            buttonState = .default
            super.isSelected = newValue
        }
    }
    
    init(variant: Variant, size: Size) {
        self.variant = variant
        self.size = size
        
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setup() {
        setupSubviews()
        setupConstraints()
        bindTouchEvent()
        
        isExclusiveTouch = true
        tintAdjustmentMode = .normal
    }

    public func setupSubviews() { }
    public func setupConstraints() { }
    public func updateState() { }
}

extension PurithmCommonButton {
    private func bindTouchEvent() {
        publisher(for: .touchDown)
            .sink { [weak self] _ in
                self?.buttonState = .pressed
            }
            .store(in: &cancellables)
        
        publisher(for: [.touchUpInside, .touchUpOutside, .touchCancel])
            .sink { [weak self] _ in
                self?.buttonState = .default
            }
            .store(in: &cancellables)
    }
}


