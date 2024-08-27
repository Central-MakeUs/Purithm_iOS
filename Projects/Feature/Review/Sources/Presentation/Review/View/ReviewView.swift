//
//  ReviewView.swift
//  Review
//
//  Created by 이숭인 on 8/9/24.
//

import UIKit
import CoreUIKit
import CoreCommonKit
import Combine

public final class ReviewView: BaseView {
    private var cancellables = Set<AnyCancellable>()
    
    let tapGesture = UITapGestureRecognizer().then {
        $0.cancelsTouchesInView = false
    }
    
    let container = UIView().then {
        $0.backgroundColor = .gray100
    }
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        $0.backgroundColor = .gray100
    }
    
    let conformButton = PlainButton(type: .filled, variant: .default, size: .large).then {
        $0.text = "올리기"
    }
    
    var conformButtonTapEvent: AnyPublisher<Void, Never> {
        conformButton.tap
    }
    
    public override func setup() {
        super.setup()
        
        self.backgroundColor = .gray100
        self.addGestureRecognizer(tapGesture)
        addKeyboardObserver()
    }
    
    public override func setupSubviews() {
        addSubview(container)
        addSubview(conformButton)
        
        container.addSubview(collectionView)
    }
    
    public override func setupConstraints() {
        container.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(conformButton.snp.top)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        conformButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(20)
        }
    }
    
    func updateConformButtonState(with isEnabled: Bool) {
        conformButton.isEnabled = isEnabled
    }
}

//MARK: - Keyboard Observe
extension ReviewView {
    private func addKeyboardObserver() {
        // 키보드가 나타날 때
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
            .receive(on: RunLoop.main)
            .sink { [weak self] notification in
                self?.handleKeyboardWillShow(notification: notification)
            }
            .store(in: &cancellables)
        
        // 키보드가 사라질 때
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
            .receive(on: RunLoop.main)
            .sink { [weak self] notification in
                self?.handleKeyboardWillHide(notification: notification)
            }
            .store(in: &cancellables)
    }
    
    func handleKeyboardWillShow(notification: Notification) {
        // 키보드가 나타날 때의 처리
        container.snp.remakeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(keyboardLayoutGuide.snp.top)
        }
    }
    
    func handleKeyboardWillHide(notification: Notification) {
        container.snp.remakeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(conformButton.snp.top)
        }
    }
}
