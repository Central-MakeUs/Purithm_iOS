//
//  PurithmAlert.swift
//  CoreUIKit
//
//  Created by 이숭인 on 7/26/24.
//

import UIKit
import Combine

public enum PurithmAlertType {
    case withOneButton(title: String, conformTitle: String)
    case withTwoButton(title: String, conformTitle: String, cancelTitle: String)
}

public final class PurithmAlert: ViewController<PurithmAlertView> {
    private var cancellables = Set<AnyCancellable>()
    
    public var conformTapEventPublisher: AnyPublisher<Void, Never> {
        contentView.conformButton.tap.eraseToAnyPublisher()
    }
    
    public var cancelTapEventPublisher: AnyPublisher<Void, Never> {
        contentView.cancelButton.tap.eraseToAnyPublisher()
    }
    
    public init(with type: PurithmAlertType) {
        super.init()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        
        switch type {
        case .withOneButton(let title, let conformTitle):
            contentView.configure(title: title, conformTitle: conformTitle)
        case .withTwoButton(let title, let conformTitle, let cancelTitle):
            contentView.configure(title: title, conformTitle: conformTitle, cancelTitle: cancelTitle)
        }
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        bindAction()
    }
    
    private func bindAction() {
        // UITapGestureRecognizer 추가
        let tapGesture = UITapGestureRecognizer()
        contentView.backgroundView.addGestureRecognizer(tapGesture)
        
        // Combine을 사용하여 제스처 인식기 이벤트를 퍼블리셔로 변환
        tapGesture.publisher(for: \.state)
            .filter { $0 == .ended }
            .sink { _ in
                AlertWindowManager.shared.hide()
            }
            .store(in: &cancellables)
    }
}

//MARK: - Public Functions
extension PurithmAlert {
    public func show(animated: Bool) {
        DispatchQueue.main.async {
            self.modalPresentationStyle = .overCurrentContext
            
            AlertWindowManager.shared.show()
            AlertWindowManager.shared.alertWindow?.rootViewController?.present(self, animated: animated)
        }
    }
    
    public func hide() {
        AlertWindowManager.shared.hide()
    }

}
