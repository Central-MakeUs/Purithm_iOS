//
//  PurithmOptionHelpBottomSheet.swift
//  CoreUIKit
//
//  Created by 이숭인 on 8/7/24.
//

import UIKit
import Combine

public final class PurithmOptionHelpBottomSheet: ViewController<PurithmOptionHelpBottomSheetView> {
    var cancellables = Set<AnyCancellable>()
    
    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        calculateContentSize()
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        bindAction()
    }
    
    private func bindAction() {
        contentView.conformTapEvent
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.dismiss(animated: true)
            }
            .store(in: &cancellables)
    }
    
    private func calculateContentSize() {
        var verticalSafeAreaInset: CGFloat = 0
        if let window = UIApplication.shared.connectedScenes
            .filter({ $0.activationState == .foregroundActive })
            .compactMap({ $0 as? UIWindowScene })
            .first?.windows
            .filter({ $0.isKeyWindow }).first {
            verticalSafeAreaInset = window.safeAreaInsets.top + window.safeAreaInsets.bottom
        }
        
        let maxHeight = UIScreen.main.bounds.height - verticalSafeAreaInset - 44
        let updatedContentSize = CGSize(width: contentView.bounds.width, height: maxHeight)
        
        if updatedContentSize != preferredContentSize {
            preferredContentSize = updatedContentSize
        }
    }
}
