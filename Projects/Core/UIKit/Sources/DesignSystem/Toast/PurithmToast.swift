//
//  PurithmToast.swift
//  CoreUIKit
//
//  Created by 이숭인 on 8/26/24.
//

import UIKit
import Combine
import CombineCocoa

public enum PurithmToastType {
    case top(message: String)
    case bottom(message: String)
}

public final class PurithmToast: ViewController<PurithmToastView> {
    private var cancellables = Set<AnyCancellable>()
    private let toastTapGesture = UITapGestureRecognizer()
    
    public init(with type: PurithmToastType) {
        super.init()
        
        switch type {
        case .top(let message):
            contentView.configure(message: message, direction: type)
        case .bottom(let message):
            contentView.configure(message: message, direction: type)
        }
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        contentView.toastContainer.addGestureRecognizer(toastTapGesture)
        
        hideToastIfNeeded()
        bindAction()
    }
    
    private func hideToastIfNeeded() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { [weak self] in
            self?.hide()
        }
    }
    
    private func bindAction() {
        toastTapGesture.tapPublisher
            .sink { [weak self] _ in
                self?.hide()
            }
            .store(in: &cancellables)
    }
}

extension PurithmToast {
    public func show(animated: Bool) {
        DispatchQueue.main.async {
            self.modalPresentationStyle = .overFullScreen
            self.modalTransitionStyle = .crossDissolve
            
            ToastWindowManager.shared.show()
            ToastWindowManager.shared.toastWindow?.rootViewController?.present(self, animated: animated)
        }
    }
    
    public func hide() {
        ToastWindowManager.shared.hide()
    }
}
