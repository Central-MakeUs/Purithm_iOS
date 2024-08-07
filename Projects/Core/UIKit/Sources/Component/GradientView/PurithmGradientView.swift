//
//  PurithmGradientView.swift
//  CoreUIKit
//
//  Created by 이숭인 on 8/5/24.
//

import UIKit
import CoreCommonKit
import SnapKit
import Then

public final class PurithmGradientView: BaseView {
    public var colorType: GradientColorType? {
        didSet {
            insertSubLayer(with: colorType)
        }
    }
    private var gradientLayer: CAGradientLayer?
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        self.gradientLayer?.frame = self.bounds
    }
    
    override public func setup() {
        super.setup()
        
        self.backgroundColor = .clear
    }
    
    private func insertSubLayer(with type: GradientColorType?) {
        switch type {
        case .blue(let direction):
            gradientLayer = makeGradientLayer(
                frame: .zero,
                startColor: .blueGradientStart,
                endColor: .blueGradientEnd,
                direction: direction
            )
        case .purple(let direction):
            gradientLayer = makeGradientLayer(
                frame: .zero,
                startColor: .purpleGradientStart,
                endColor: .purpleGradientEnd,
                direction: direction
            )
        case .white(let direction):
            gradientLayer = makeGradientLayer(
                frame: .zero,
                startColor: .whiteGradientStart,
                endColor: .whiteGradientEnd,
                direction: direction
            )
        default:
            break
        }
        
        guard let gradientLayer = gradientLayer else { return }
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    public func show() {
        self.alpha = 1
    }
    
    public func hide() {
        self.alpha = 0
    }
    
    private func makeGradientLayer(frame: CGRect, startColor: UIColor, endColor: UIColor, direction: GradientDirection) -> CAGradientLayer {
        let colors = [startColor, endColor]
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.frame = frame
        
        switch direction {
        case .top:
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
            gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.0)
        case .leading:
            gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.0)
            gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.0)
        case .trailing:
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)
        case .bottom:
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
            gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
        }
        
        return gradientLayer
    }
}
