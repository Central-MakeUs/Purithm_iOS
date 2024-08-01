//
//  TextButton.swift
//  CoreUIKit
//
//  Created by 이숭인 on 7/26/24.
//

import UIKit
import SnapKit

public final class TextButton: PurithmCommonButton {
    // MARK: - Views
    private let label = UILabel()

    // MARK: - UI Properties
    /// button label text
    public var text: String? {
        didSet { updateText() }
    }

    // MARK: - Initializers
    public override init(variant: Variant, size: Size) {
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
        label.setContentCompressionResistancePriority(priority, for: axis)
    }

    public override func setup() {
        super.setup()

        backgroundColor = .clear

        updateState()
    }

    public override func setupSubviews() {
        addSubview(label)
    }

    public override func setupConstraints() {
        label.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(20)
            make.leading.greaterThanOrEqualToSuperview()
            make.trailing.lessThanOrEqualToSuperview()
            make.centerX.equalToSuperview()
        }
    }

    public override func updateState() {
        updateText()
        updateTypography()
    }
}

// MARK: - update
extension TextButton {
    private func updateText() {
        label.text = text
    }
}

// MARK: - update
extension TextButton {
    private func updateTypography() {
        label.applyTypography(with: typography)
    }
}

// MARK: - Typography
extension TextButton {
    private var typography: Typography {
        switch size {
        case .large: return Typography(size: .size16, weight: .semibold, color: fontColor, applyLineHeight: false)
        case .medium: return Typography(size: .size16, weight: .semibold, color: fontColor, applyLineHeight: false)
        case .small: return Typography(size: .size16, weight: .semibold, color: fontColor, applyLineHeight: false)
        case .xsmall: return Typography(size: .size14, weight: .semibold, color: fontColor, applyLineHeight: false)
        }
    }
}

// MARK: - Colors
extension TextButton {
    private var fontColor: UIColor {
        switch (variant, buttonState) {
        case (.primary, _): return .blue400
        case (.secondary, _): return .gray300
        default: return .blue400
        }
    }
}

