//
//  PlanButton.swift
//  CoreUIKit
//
//  Created by 이숭인 on 7/25/24.
//

import UIKit
import SnapKit
import Then

//TODO: 이동 필요?
public enum ButtonImagePosition {
    case start
    case end
}

public enum ButtonShape {
    case squares
    case circle
}

extension ButtonShape {
    public func getRadius(with size: PurithmCommonButton.Size) -> CGFloat {
        switch self {
        case .squares: return 12
        case .circle: return size.rawValue / 2
        }
    }
}
///

extension PlainButton {
    public enum `Type` {
        case filled
        case transparent
    }
}

public final class PlainButton: PurithmCommonButton {
    //MARK: Properties
    private let type: `Type`
    private let theme: PlainButtonThemeType
    
    //MARK: UI Properties

    //MARK: Views
    private let container = UIView().then {
        $0.clipsToBounds = true
        $0.isUserInteractionEnabled = false
    }
    private let highlightDimmedView = UIView().then {
        $0.isUserInteractionEnabled = false
    }
    private let stackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 0
        $0.alignment = .center
        $0.distribution = .fill
        $0.isUserInteractionEnabled = false
    }
    private let imageView = UIImageView()
    private let additionalImageView = UIImageView()
    private let titleLabel = UILabel()
    
    // MARK: - UI Properties
    /// button label text
    public var text: String? {
        didSet { updateText() }
    }

    /// button image
    public var image: UIImage? {
        didSet { updateImage() }
    }

    /// button additional image. imagePosition의 반대 반향에 위치
    public var additionalImage: UIImage? {
        didSet { updateAdditionalImage() }
    }

    /// image 위치. start인 경우 좌측, end인 경우 우측
    public var imagePosition: ButtonImagePosition = .start {
        didSet { updateImagePosition(with: oldValue) }
    }

    /// corner radius. squares인 경우 6, circle인 경우 높이 / 2
    public var shape: ButtonShape = .squares {
        didSet { updateShape() }
    }

    /// shadow를 노출 여부
    public var hasShadow: Bool = false {
        didSet {
            updateShadow()
            updateDefaultBackgroundColor()
        }
    }

    /// 가로 크기가 늘어날지 자기 자신의 크기를 가질지 결정
    public var isStretch: Bool = true {
        didSet { updateStretch() }
    }

    /// hasShadow가 true인 경우에만 적용되는 backgroundColor
    public lazy var defaultBackgroundColor: UIColor = theme.defaultBackgroundColor {
        didSet { updateDefaultBackgroundColor() }
    }
    
    public init(type: `Type`,
                variant: PurithmCommonButton.Variant,
                size: PurithmCommonButton.Size,
                theme: PlainButtonTheme = .default) {
        self.type = type
        self.theme = theme.instance
        
        super.init(variant: variant, size: size)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Override Methods
    public override func sizeThatFits(_ size: CGSize) -> CGSize {
        systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }

    public override func setContentCompressionResistancePriority(_ priority: UILayoutPriority, for axis: NSLayoutConstraint.Axis) {
        super.setContentCompressionResistancePriority(priority, for: axis)
        titleLabel.setContentCompressionResistancePriority(priority, for: axis)
    }
    
    public override func setup() {
        super.setup()
        
        layer.borderWidth = 1
        layer.shadowColor = UIColor.black.withAlphaComponent(0.12).cgColor
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 3.0
        
        setupStackView()
        updateState()
        updateText()
        updateImage()
        updateAdditionalImage()
        updateShape()
        updateShadow()
        updateDefaultBackgroundColor()
    }
    
    public override func setupSubviews() {
        addSubview(container)
        container.addSubview(highlightDimmedView)
        container.addSubview(stackView)
        
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(additionalImageView)
    }
    
    public override func setupConstraints() {
        container.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(size.rawValue)
        }
        
        highlightDimmedView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { make in
            make.top.bottom.centerX.equalToSuperview()
            make.leading.greaterThanOrEqualToSuperview()
            make.trailing.lessThanOrEqualToSuperview()
        }

        imageView.snp.makeConstraints { make in
            make.size.equalTo(imageSize)
        }

        additionalImageView.snp.makeConstraints { make in
            make.size.equalTo(imageSize)
        }
    }
    
    public override func updateState() {
        updateColors()
        updateTypography()
    }
    
    private func setupStackView() {
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = size.layoutMargin
        stackView.spacing = size.spacing
    }
}

// MARK: - update
extension PlainButton {
    private func updateText() {
        titleLabel.text = text
        titleLabel.isHidden = text == nil
    }

    private func updateImage() {
        imageView.image = image
        imageView.isHidden = image == nil
    }

    private func updateAdditionalImage() {
        additionalImageView.image = additionalImage
        additionalImageView.isHidden = additionalImage == nil
    }
    
    private func updateColors() {
        UIView.animate(withDuration: 0.15) {
            self.container.backgroundColor = self.backgroundColors
            self.highlightDimmedView.backgroundColor = self.highlightDimmedColor
        }
        layer.borderColor = borderColors
        imageView.tintColor = fontColor
        additionalImageView.tintColor = fontColor
    }

    private func updateTypography() {
        titleLabel.applyTypography(with: typography)
    }
    
    private func updateImagePosition(with oldValue: ButtonImagePosition) {
        guard imagePosition != oldValue else { return }

        imageView.removeFromSuperview()
        additionalImageView.removeFromSuperview()

        if imagePosition == .start {
            stackView.insertArrangedSubview(imageView, at: 0)
            stackView.addArrangedSubview(additionalImageView)
        } else {
            stackView.insertArrangedSubview(additionalImageView, at: 0)
            stackView.addArrangedSubview(imageView)
        }
    }

    private func updateShape() {
        layer.cornerRadius = shape.getRadius(with: size)
        container.layer.cornerRadius = shape.getRadius(with: size)
    }

    private func updateShadow() {
        layer.shadowOpacity = hasShadow ? 1.0 : 0.0
    }

    private func updateStretch() {
        stackView.snp.remakeConstraints { make in
            make.top.bottom.centerX.equalToSuperview()
            if isStretch {
                make.leading.greaterThanOrEqualToSuperview()
                make.trailing.lessThanOrEqualToSuperview()
            } else {
                make.leading.trailing.equalToSuperview()
            }
        }
    }

    private func updateDefaultBackgroundColor() {
        if hasShadow {
            backgroundColor = defaultBackgroundColor
        } else {
            backgroundColor = .clear
        }
    }
}

// MARK: - Typography
extension PlainButton {
    private var typography: Typography {
        switch size {
        case .xlarge: return Typography(size: .size18, weight: .semibold, color: fontColor, applyLineHeight: false)
        case .large: return Typography(size: .size16, weight: .semibold, color: fontColor, applyLineHeight: false)
        case .medium: return Typography(size: .size16, weight: .semibold, color: fontColor, applyLineHeight: false)
        case .small: return Typography(size: .size14, weight: .semibold, color: fontColor, applyLineHeight: false)
        case .xsmall: return Typography(size: .size12, weight: .semibold, color: fontColor, applyLineHeight: false)
        }
    }
}

// MARK: - ImageSize
extension PlainButton {
    private var imageSize: CGFloat {
        switch size {
        case .xlarge: return 24
        case .large: return 18
        case .medium: return 18
        case .small: return 16
        case .xsmall: return 14
        }
    }
}

// MARK: - Colors
extension PlainButton {
    private var fontColor: UIColor {
        theme.fontColor(type: type, variant: variant, buttonState: buttonState)
    }

    private var backgroundColors: UIColor {
        theme.backgroundColors(type: type, variant: variant, buttonState: buttonState)
    }

    private var highlightDimmedColor: UIColor {
        theme.highlightDimmedColor(type: type, variant: variant, buttonState: buttonState)
    }

    private var borderColors: CGColor {
        theme.borderColors(type: type, variant: variant, buttonState: buttonState)
    }
}
