//
//  PurithmMenuBottomSheet.swift
//  CoreUIKit
//
//  Created by 이숭인 on 8/6/24.
//

import UIKit
import Combine

public final class PurithmMenuBottomSheet: ViewController<PurithmMenuBottomSheetView> {
    var cancellables = Set<AnyCancellable>()
    public var menuTapEvent: AnyPublisher<String, Never> {
        contentView.menuTapEvent
    }
    
    /// 메뉴를 입력합니다.
    public var menus: [PurithmMenuModel]?
    
    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        calculateContentSize()
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        guard let menus = menus else { return }
        contentView.configure(with: menus)
        bindAction()
    }
    
    private func bindAction() {
        contentView.menuTapEvent
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
        let fittingSize = contentView.container.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        
        let contentHeight = fittingSize + 20
        let updatedContentSize = CGSize(width: contentView.bounds.width, height: min(contentHeight, maxHeight))
        
        if updatedContentSize != preferredContentSize {
            preferredContentSize = updatedContentSize
        }
    }
}
