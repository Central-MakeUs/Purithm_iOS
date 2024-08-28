//
//  ProfileEditTextFieldComponent.swift
//  Profile
//
//  Created by 이숭인 on 8/22/24.
//

import UIKit
import CoreUIKit
import CoreCommonKit
import Combine
import RxSwift
import RxCocoa

struct ProfileEditViewAction: ActionEventItem {
    let text: String
}

struct ProfileEditTextFieldComponent: Component {
    var identifier: String
    let name: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}

extension ProfileEditTextFieldComponent {
    typealias ContentType = ProfileEditTextFieldView
    
    func render(content: ContentType, context: Self, cancellable: inout Set<AnyCancellable>) {
        content.configure(name: context.name)
        
        content.editTextField.textPublisher
            .removeDuplicates()
            .sink { [weak content] text in
                guard let text else { return }
                
                content?.updateTextCount(with: text.count)
                content?.actionEventEmitter.send(ProfileEditViewAction(text: text))
            }
            .store(in: &cancellable)
        
        content.editTextField.rx.controlEvent(.editingDidEndOnExit)
            .asPublisher()
            .sink { _ in } receiveValue: { [weak content] in
                content?.checkTextCount()
            }
            .store(in: &cancellable)
        
        content.editTextField.rx.controlEvent(.editingDidEnd)
            .asPublisher()
            .sink { _ in } receiveValue: { [weak content] in
                content?.checkTextCount()
            }
            .store(in: &cancellable)
    }
}

final class ProfileEditTextFieldView: BaseView, ActionEventEmitable {
    var actionEventEmitter = PassthroughSubject<ActionEventItem, Never>()
    
    let container = UIView()
    let titleLabel = PurithmLabel(typography: Constants.titleTypo).then {
        $0.text = "닉네임"
    }
    let editTextField = UITextField().then {
        $0.layer.cornerRadius = 12
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.gray300.cgColor
        $0.textColor = .gray500
    }
    
    let bottomLabelContainer = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.alignment = .center
    }
    let descriptionLabel = PurithmLabel(typography: Constants.descriptionTypo).then {
        $0.text = "국문 또는 영문으로 띄어쓰기 없이 작성해주세요."
    }
    let countLabel = PurithmLabel(typography: Constants.countTypo).then {
        $0.text = "0"
        $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
    let maxCountLabel = PurithmLabel(typography: Constants.maxCountTypo).then {
        $0.text = "/12"
    }
    
    override func setup() {
        super.setup()
        
        self.backgroundColor = .gray100
        
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 60))
        editTextField.leftView = leftPaddingView
        editTextField.leftViewMode = .always

        let rightPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 60))
        editTextField.rightView = rightPaddingView
        editTextField.rightViewMode = .always
    }
    
    override func setupSubviews() {
        addSubview(container)
        container.addSubview(titleLabel)
        container.addSubview(editTextField)
        container.addSubview(bottomLabelContainer)
        
        bottomLabelContainer.addArrangedSubview(descriptionLabel)
        bottomLabelContainer.addArrangedSubview(countLabel)
        bottomLabelContainer.addArrangedSubview(maxCountLabel)
    }
    
    override func setupConstraints() {
        container.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }
        
        editTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(60)
        }
        
        bottomLabelContainer.snp.makeConstraints { make in
            make.top.equalTo(editTextField.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    func configure(name: String) {
        editTextField.placeholder = "닉네임을 입력해주세요."
        
        if !name.isEmpty {
            editTextField.text = name
        }
    }
    
    func updateTextCount(with count: Int) {
        let countTrigger = count >= 1 && count <= 12
        
        countLabel.text = "\(count)"
        countLabel.textColor = countTrigger ? .blue400 : .red500
        
        descriptionLabel.text = "국문 또는 영문으로 띄어쓰기 없이 작성해주세요."
        descriptionLabel.textColor = .gray300
        
        editTextField.layer.borderColor = UIColor.blue400.cgColor
    }
    
    func checkTextCount() {
        guard let count = editTextField.text?.count else {
            descriptionLabel.text = "국문 또는 영문으로 띄어쓰기 없이 작성해주세요."
            descriptionLabel.textColor = .gray300
            return
        }
        
        let countTrigger = count >= 1 && count <= 12
        descriptionLabel.text = countTrigger ? "국문 또는 영문으로 띄어쓰기 없이 작성해주세요." : "최소 1자 이상, 최대 12자 이하로 입력해주세요."
        descriptionLabel.textColor = countTrigger ? .gray300 : .red500
        editTextField.layer.borderColor = countTrigger ? UIColor.blue400.cgColor : UIColor.red500.cgColor
    }
}

extension ProfileEditTextFieldView {
    private enum Constants {
        static let titleTypo = Typography(size: .size14, weight: .semibold, color: .gray500, applyLineHeight: true)
        static let descriptionTypo = Typography(size: .size14, weight: .medium, color: .gray300, applyLineHeight: true)
        static let countTypo = Typography(size: .size14, weight: .medium, color: .gray300, applyLineHeight: true)
        static let maxCountTypo = Typography(size: .size14, weight: .medium, color: .gray300, applyLineHeight: true)
    }
}

