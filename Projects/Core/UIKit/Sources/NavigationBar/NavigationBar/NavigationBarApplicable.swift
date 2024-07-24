//
//  NavigationBarApplicable.swift
//  CoreUIKit
//
//  Created by 이숭인 on 7/23/24.
//

import UIKit
import CoreCommonKit
import RxSwift
import RxCocoa

public protocol NavigationBarApplicable where Self: UIViewController {
    var leftButtonItems: [NavigationBarButtonItemType] { get }
    var rightButtonItems: [NavigationBarButtonItemType] { get }
    func initNavigationBar(with type: NavigationBarType, hideShadow: Bool)
    func initNavigationTitleView(with type: NavigationBarType, title: String, subtitle: String)
    func handleNavigationButtonAction(with identifier: String)
}

// MARK: - default values
extension NavigationBarApplicable {
    public var leftButtonItems: [NavigationBarButtonItemType] { [] }
    public var rightButtonItems: [NavigationBarButtonItemType] { [] }
    public func handleNavigationButtonAction(with identifier: String) { }
}

// MARK: - AssociationKeys
private enum AssociationKeys {
    static var type: UInt8 = 0
}

// MARK: - navigationBarType
extension NavigationBarApplicable {
    public var navigationBarType: NavigationBarType {
        get { objc_getAssociatedObject(self, &AssociationKeys.type) as? NavigationBarType ?? .page }
        set { objc_setAssociatedObject(self, &AssociationKeys.type, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
}

// MARK: - initialize
extension NavigationBarApplicable {
    public func initNavigationBar(with type: NavigationBarType = .page, hideShadow: Bool = false) {
        navigationItem.hidesBackButton = true

        initAppearance(type: type, hideShadow: hideShadow)
        initBarStyle(type: type)
        navigationItem.leftBarButtonItems = buttonItems(for: leftButtonItems)
        navigationItem.rightBarButtonItems = buttonItems(for: rightButtonItems)
        bindNavigationBarHiddenIfNeeded(with: type)
    }

    public func initNavigationTitleView(with type: NavigationBarType = .page, title: String = "", subtitle: String = "") {

        guard let titleView = navigationItem.titleView as? PurithmNavigationTitleView else {
            navigationItem.titleView = PurithmNavigationTitleView(with: type, title: title)
            return
        }

        guard titleView.superview != nil else {
            navigationItem.titleView = PurithmNavigationTitleView(with: type, title: title)
            return
        }

        if titleView.type != type || titleView.title != title {
            navigationItem.titleView = PurithmNavigationTitleView(with: type, title: title)
        }
    }
}

extension NavigationBarApplicable {
    private func initAppearance(type: NavigationBarType, hideShadow: Bool) {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = type.backgroundColor
        appearance.shadowColor = .clear
        appearance.shadowImage = hideShadow ? UIColor.clear.as1pxImage() : UIColor.black005.as1pxImage()
        appearance.titlePositionAdjustment = type.titlePositionAdjustment
        
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.compactAppearance = appearance
    }
    
    private func initBarStyle(type: NavigationBarType) {
        navigationBarType = type
        setNeedsStatusBarAppearanceUpdate()
    }
    
    private func bindNavigationBarHiddenIfNeeded(with type: NavigationBarType) {
//        guard type != .page else { return }
        let isHidden = !(type == .page)
        navigationController?.isNavigationBarHidden = true
        
        rx.viewWillAppear
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.navigationController?.isNavigationBarHidden = isHidden
            })
            .disposed(by: rx.disposeBag)
        
        rx.viewWillDisappear
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard self?.presentedViewController == nil else { return }
                self?.navigationController?.isNavigationBarHidden = isHidden
            })
            .disposed(by: rx.disposeBag)
    }
}
 
// MARK: - Bar Button Items
extension NavigationBarApplicable {
    private func mapToBarButtonItem(type: NavigationBarButtonItemType) -> UIBarButtonItem {
        let item = type.makeBarButtonItem()
        let tapObservable = if let item = item as? PurithmBarButtonItem {
            item.button.rx.tap
        } else {
            item.rx.tap
        }

        tapObservable
            .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self, weak item] in
                guard let item else { return }

                switch type {
                case .backText(_, _, _, let enableAutoClose) where enableAutoClose:
                    self?.closeViewController(animated: true)
                case .backImage(_, _, _, let enableAutoClose) where enableAutoClose:
                    self?.closeViewController(animated: true)
                default:
                    self?.handleNavigationButtonAction(with: type.identifier)
                }
            })
            .disposed(by: item.rx.disposeBag)

        return item
    }

    
    private func buttonItems(for items: [NavigationBarButtonItemType]) -> [UIBarButtonItem] {
        let items = items
            .map(mapToBarButtonItem)

        let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace,
                                     target: nil, action: nil)
        return [spacer] + items
    }
}

extension UIColor {
    func as1pxImage() -> UIImage {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        setFill()
        UIGraphicsGetCurrentContext()?.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let image = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
        UIGraphicsEndImageContext()
        return image
    }
}
