//
//  UIViewController+CloseViewController.swift
//  CoreUIKit
//
//  Created by 이숭인 on 7/23/24.
//

import UIKit

extension UIViewController {
    /// navigationController가 있고, viewControllers가 1개 이상일때 pop 가능.
    private var navigationControllerIfCanPop: UINavigationController? {
        guard let navigationController = navigationController ?? (self as? UINavigationController) else {
            return nil
        }
        return navigationController.viewControllers.count > 1 ? navigationController : nil
    }

    public var canGoBack: Bool {
        navigationControllerIfCanPop != nil
    }

    public func closeViewController(animated: Bool, completion: (() -> Void)? = nil) {
        if let navigationController = navigationControllerIfCanPop {
            navigationController.popViewController(animated: animated)

            if animated, let coordinator = navigationController.transitionCoordinator {
                coordinator.animate(alongsideTransition: nil) { _ in
                    completion?()
                }
            } else {
                completion?()
            }
        } else if presentedViewController != nil || presentingViewController != nil {
            // present된( 자식 ) viewController가 있거나 present시킨( 부모 ) viewController가 있는 경우 dismiss
            dismiss(animated: animated, completion: completion)
        }
    }

    public func returnToMe(animated: Bool, completion: (() -> Void)? = nil) {
        if presentedViewController != nil {
            dismiss(animated: animated) { [weak self] in
                self?.popToMe(animated: completion == nil && animated)
                completion?()
            }
        } else {
            popToMe(animated: completion == nil && animated)
            completion?()
        }
    }

    private func popToMe(animated: Bool) {
        guard navigationController?.viewControllers.contains(self) == true
        else { return }

        navigationController?.popToViewController(self,
                                                  animated: animated)
    }
}
