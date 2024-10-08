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
    private let menuTapEventSubject = PassthroughSubject<String, Never>()
    public var menuTapEvent: AnyPublisher<String, Never> {
        menuTapEventSubject.eraseToAnyPublisher()
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
            .sink { [weak self] identifier in
                self?.dismiss(animated: true) { [weak self] in
                    self?.menuTapEventSubject.send(identifier)
                }
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
        let fittingSize = contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        let contentVerticalSafeAreaHeight = contentView.safeAreaInsets.top + contentView.safeAreaInsets.bottom
        
        let contentHeight = fittingSize - contentVerticalSafeAreaHeight
        let updatedContentSize = CGSize(width: contentView.bounds.width, height: min(contentHeight, maxHeight))
        
        if updatedContentSize != preferredContentSize {
            preferredContentSize = updatedContentSize
        }
    }
}
