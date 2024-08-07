//
//  PurithmContentBottomSheet.swift
//  CoreUIKit
//
//  Created by 이숭인 on 8/7/24.
//


import UIKit
import Combine

public final class PurithmContentBottomSheet: ViewController<PurithmContentBottomSheetView> {
    var cancellables = Set<AnyCancellable>()
    public var contentModel: PurithmContentModel?
    
    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        calculateContentSize()
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        guard let contentModel = contentModel else {
            dismiss(animated: true)
            return
        }
        
        bindAction()
        contentView.configure(
            with: contentModel.contentType,
            title: contentModel.title,
            description: contentModel.description)
        
        updateViewConstraints()
    }
    
    private func bindAction() {
        contentView.conformTapEvent
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.dismiss(animated: true)
            }
            .store(in: &cancellables)
    }
}

//MARK: - Calculate content size
extension PurithmContentBottomSheet {
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
        let fittingSize = contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        let contentVerticalSafeAreaHeight = contentView.safeAreaInsets.top + contentView.safeAreaInsets.bottom
        
        let contentHeight = fittingSize - contentVerticalSafeAreaHeight
        let updatedContentSize = CGSize(width: contentView.bounds.width, height: min(contentHeight, maxHeight))
        
        if updatedContentSize != preferredContentSize {
            preferredContentSize = updatedContentSize
        }
    }
}
