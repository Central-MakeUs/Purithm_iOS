//
//  PurithmBlurButton.swift
//  CoreUIKit
//
//  Created by 이숭인 on 8/8/24.
//

import UIKit
import CoreCommonKit
import SnapKit
import Then
import Combine

//TODO: 완전히 다시 만들어야함. 일단 적용하자 ..
extension PurithmBlurButton {
    public enum State {
        case `default`
        case pressed
        case disabled
    }
    
    public enum Size: CGFloat {
        case normal = 36
        
        var layoutMargin: UIEdgeInsets {
            switch self {
            case .normal:
                return UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 12)
            }
        }
        
        var spacing: CGFloat {
            switch self {
            case .normal:
                return 8
            }
        }
    }
}

public enum BlurButtonShape {
    case squares
    case circle
}


extension BlurButtonShape {
    public func getRadius(with size: PurithmBlurButton.Size) -> CGFloat {
        switch self {
        case .squares: return 12
        case .circle: return size.rawValue / 2
        }
    }
}

public final class PurithmBlurButton: UIControl {
    //MARK: - Properties
    private var cancellables = Set<AnyCancellable>()
    
    var size: Size
    private(set) var buttonState: State = .default {
        didSet { updateState() }
    }
    
    //MARK: Views
    private let container = UIView().then {
        $0.backgroundColor = .clear
        $0.clipsToBounds = true
        $0.isUserInteractionEnabled = false
    }
    private let highlightDimmedView = UIView().then {
        $0.isUserInteractionEnabled = false
    }
    private let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    
    private let stackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 0
        $0.alignment = .center
        $0.distribution = .fill
        $0.isUserInteractionEnabled = false
    }
    private let imageView = UIImageView().then {
        $0.layer.cornerRadius = 28 / 2
        $0.clipsToBounds = true
    }
    private let additionalImageView = UIImageView()
    private let titleLabel = PurithmLabel(typography: Constants.titleTypo)
    
    
    //MARK: - UI Properties
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
    
    /// corner radius. squares인 경우 6, circle인 경우 높이 / 2
    public var shape: BlurButtonShape = .squares {
        didSet { updateShape() }
    }

    /// shadow를 노출 여부
    public var hasShadow: Bool = false {
        didSet {
            updateShadow()
        }
    }
    
    public var hasContentShdaow: Bool = false {
        didSet {
            updateContentShadow()
        }
    }
    
    public init(size: PurithmBlurButton.Size) {
        self.size = size
        super.init(frame: .zero)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Override Methods
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        blurEffectView.frame = container.bounds
        print("::: blurEffectView.frame > \(blurEffectView.frame)")
    }
    
    public override func sizeThatFits(_ size: CGSize) -> CGSize {
        systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }

    public override func setContentCompressionResistancePriority(_ priority: UILayoutPriority, for axis: NSLayoutConstraint.Axis) {
        super.setContentCompressionResistancePriority(priority, for: axis)
        titleLabel.setContentCompressionResistancePriority(priority, for: axis)
    }
    
    public func setup() {
        setupSubviews()
        setupConstraints()
        bindTouchEvent()
        
        
        setupStackView()
        setupShadow()
        updateState()
        updateText()
        updateImage()
        updateAdditionalImage()
        updateShape()
        
        isExclusiveTouch = true
        tintAdjustmentMode = .normal
    }
    
    public func setupSubviews() { 
        addSubview(container)
        container.addSubview(blurEffectView)
        container.addSubview(highlightDimmedView)
        container.addSubview(stackView)
        
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(additionalImageView)
    }
    
    public func setupConstraints() {
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
            make.size.equalTo(additionalImageSize)
        }
    }
}

// MARK: - ImageSize
extension PurithmBlurButton {
    private var imageSize: CGFloat {
        switch size {
        case .normal:
            return 28
        }
    }
    
    private var additionalImageSize: CGFloat {
        switch size {
        case .normal:
            return 20
        }
    }
}

// MARK: - update
extension PurithmBlurButton {
    private func updateText() {
        titleLabel.text = text
        titleLabel.font = UIFont.EBGaramond.semiBold.font(size: 18)
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
        UIView.animate(withDuration: 0.15) { [weak self] in
            switch self?.buttonState {
            case .default:
                self?.container.backgroundColor = .clear
            case .pressed:
                self?.container.backgroundColor = .black040
            default:
                break
            }
        }

        imageView.tintColor = .white
        additionalImageView.tintColor = .white
    }
    
    private func updateShape() {
        layer.cornerRadius = shape.getRadius(with: size)
        container.layer.cornerRadius = shape.getRadius(with: size)
    }
    
    private func updateShadow() {
        layer.shadowOpacity = hasShadow ? 1.0 : 0.0
    }
    
    private func updateContentShadow() {
        if hasContentShdaow {
            titleLabel.layer.shadowOpacity = 0.5
            imageView.layer.shadowOpacity = 0.5
            additionalImageView.layer.shadowOpacity = 0.5
        }
    }
    
    public func updateState() {
        updateColors()
    }
    
    private func setupStackView() {
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = size.layoutMargin
        stackView.spacing = size.spacing
    }
    
    private func setupShadow() {
        layer.shadowColor = UIColor.black.withAlphaComponent(0.25).cgColor
        layer.shadowOffset = CGSize(width: 2, height: 2)
        layer.shadowRadius = 3.0
        
        additionalImageView.layer.shadowOffset = CGSize(width: 2, height: 2)
        additionalImageView.layer.shadowRadius = 3.0
        titleLabel.layer.shadowOffset = CGSize(width: 2, height: 2)
        titleLabel.layer.shadowRadius = 3.0
        imageView.layer.shadowOffset = CGSize(width: 2, height: 2)
        imageView.layer.shadowRadius = 3.0
    }
}

//MARK: Typography
extension PurithmBlurButton {
    private enum Constants {
        static let titleTypo = Typography(size: .size18, weight: .semibold, color: .white, applyLineHeight: true)
    }
}

extension PurithmBlurButton {
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
