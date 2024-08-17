//
//  ReviewTextViewComponent.swift
//  Review
//
//  Created by 이숭인 on 8/9/24.
//

import UIKit
import CoreUIKit
import CoreCommonKit
import Combine
import CombineCocoa


struct ReviewTextViewAction: ActionEventItem {
    let text: String
}

struct ReviewTextViewComponent: Component {
    var identifier: String
    
    func hash(into hasher: inout Hasher) {
        
    }
}

extension ReviewTextViewComponent {
    typealias ContentType = ReviewTextViewView
    
    func render(content: ContentType, context: Self, cancellable: inout Set<AnyCancellable>) {
        content.textView.textPublisher
            .sink { [weak content] text in
                guard let text else { return }
                
                content?.updateTextCount(with: text.count)
                
                content?.actionEventEmitter.send(ReviewTextViewAction(text: text))
            }
            .store(in: &cancellable)
        
        content.textView.rx.didEndEditing
            .asPublisher()
            .sink { [weak content] _ in
                content?.changeFocusState(isFocus: false)
            }
            .store(in: &cancellable)
        
        content.textView.rx.didBeginEditing
            .asPublisher()
            .sink { [weak content] _ in
                content?.changeFocusState(isFocus: true)
            }
            .store(in: &cancellable)
        
        content.containerTapGesture.tapPublisher
            .sink { [weak content] _ in
                content?.textView.endEditing(true)
            }
            .store(in: &cancellable)
    }
}

final class ReviewTextViewView: BaseView, ActionEventEmitable {
    var actionEventEmitter = PassthroughSubject<ActionEventItem, Never>()
    
    let container = UIView().then {
        $0.backgroundColor = .gray100
    }
    let containerTapGesture = UITapGestureRecognizer()
    
    let titleLabel = PurithmLabel(typography: Constants.titleTypo).then {
        $0.text = "필터 사용 후기를 남겨주세요."
    }
    
    let descriptionLabel = PurithmLabel(typography: Constants.descriptionTypo).then {
        $0.text = "(필수) 텍스트 20자 이상"
    }
    
    let textView = PlaceholderTextView().then {
        $0.layer.cornerRadius = 12
        $0.font = UIFont.Pretendard.medium.font(size: 16)
        $0.textColor = .gray500
        $0.placeholder = "여기에 남겨주세요."
        $0.placeholderColor = .gray200
        $0.textContainerInset = UIEdgeInsets(top: 20, left: 20, bottom: 30, right: 20)
    }
    let countLabel = PurithmLabel(typography: Constants.countTypo)
    let textCountLabel = PurithmLabel(typography: Constants.textCountTypo).then {
        $0.text = "/100 (최소 20자)"
    }
    
    let maxLength = 100
    
    override func setup() {
        super.setup()
        
        self.addGestureRecognizer(containerTapGesture)
        textView.delegate = self
    }
    
    override func setupSubviews() {
        addSubview(container)
        self.backgroundColor = .gray100
        
        container.addSubview(titleLabel)
        container.addSubview(descriptionLabel)
        container.addSubview(textView)
        
        container.addSubview(countLabel)
        container.addSubview(textCountLabel)
    }
    
    override func setupConstraints() {
        container.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(60)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview()
        }
        
        textView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(200)
        }
        
        countLabel.snp.makeConstraints { make in
            make.bottom.equalTo(textView.snp.bottom).offset(-20)
            make.trailing.equalTo(textCountLabel.snp.leading)
        }
        
        textCountLabel.snp.makeConstraints { make in
            make.bottom.equalTo(textView.snp.bottom).offset(-20)
            make.trailing.equalTo(textView.snp.trailing).offset(-20)
        }
    }
    
    func updateTextCount(with count: Int) {
        countLabel.text = "\(count)"
    
        countLabel.textColor =  count >= 20 ? .blue400 : .red500
        textView.layer.borderColor =  count >= 20 ? UIColor.blue300.cgColor : UIColor.red500.cgColor
    }
    
    func changeFocusState(isFocus: Bool) {
        let minLength = 20
        let focusColor = textView.text.count >= minLength ? UIColor.blue300.cgColor : UIColor.red500.cgColor
        
        textView.layer.borderWidth = isFocus ? 1 : 0
        textView.layer.borderColor = isFocus ? focusColor : UIColor.clear.cgColor
    }
}

extension ReviewTextViewView {
    private enum Constants {
        static let titleTypo = Typography(size: .size18, weight: .semibold, color: .gray500, applyLineHeight: true)
        static let descriptionTypo = Typography(size: .size14, weight: .medium, color: .gray300, applyLineHeight: true)
        
        static let textCountTypo = Typography(size: .size14, weight: .medium, color: .gray300, applyLineHeight: true)
        static let countTypo = Typography(size: .size14, weight: .medium, color: .blue400, applyLineHeight: true)
    }
}

extension ReviewTextViewView: UITextViewDelegate {
    // UITextViewDelegate 메서드를 사용하여 100자 이상 입력 막기
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
        
        return updatedText.count <= maxLength
    }
}

import UIKit

class PlaceholderTextView: UITextView {

    // Placeholder 텍스트를 위한 레이블
    private let placeholderLabel: UILabel = UILabel()
    
    // Placeholder 텍스트
    var placeholder: String? {
        didSet {
            placeholderLabel.text = placeholder
            placeholderLabel.sizeToFit()
        }
    }
    
    // Placeholder 텍스트의 색상
    var placeholderColor: UIColor = .lightGray {
        didSet {
            placeholderLabel.textColor = placeholderColor
        }
    }
    
    override var text: String! {
        didSet {
            textDidChange()
        }
    }
    
    override var attributedText: NSAttributedString! {
        didSet {
            textDidChange()
        }
    }
    
    override var font: UIFont? {
        didSet {
            placeholderLabel.font = font
            placeholderLabel.sizeToFit()
        }
    }

    override var textAlignment: NSTextAlignment {
        didSet {
            placeholderLabel.textAlignment = textAlignment
        }
    }

    // 초기화
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        self.backgroundColor = .white
        setupPlaceholder()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupPlaceholder()
    }
    
    private func setupPlaceholder() {
        // Placeholder 레이블 설정
        placeholderLabel.textColor = placeholderColor
        placeholderLabel.font = font
        placeholderLabel.textAlignment = textAlignment
        placeholderLabel.numberOfLines = 0
        placeholderLabel.backgroundColor = .clear
        placeholderLabel.isHidden = !text.isEmpty
        
        addSubview(placeholderLabel)
        
        // 텍스트 변경 이벤트를 감지
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(textDidChange),
                                               name: UITextView.textDidChangeNotification,
                                               object: self)
    }
    
    @objc private func textDidChange() {
        placeholderLabel.isHidden = !text.isEmpty
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        placeholderLabel.frame.origin = CGPoint(x: textContainerInset.left + textContainer.lineFragmentPadding,
                                                y: textContainerInset.top)
        placeholderLabel.frame.size.width = frame.width - (textContainerInset.left + textContainerInset.right + textContainer.lineFragmentPadding * 2)
        placeholderLabel.sizeToFit()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
