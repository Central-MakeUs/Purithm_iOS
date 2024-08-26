//
//  ToastWindowManager.swift
//  CoreUIKit
//
//  Created by 이숭인 on 8/26/24.
//

import UIKit

public class ToastWindowManager {
    static var shared = ToastWindowManager()

    var toastWindow: ToastWindow?

    private init() {
        let windowScene = UIApplication.shared
            .connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .first
        if let windowScene = windowScene as? UIWindowScene {
            toastWindow = ToastWindow(windowScene: windowScene)
        }
    }

    func show() {
        toastWindow?.isHidden = false
        toastWindow?.rootViewController = UIViewController()
        toastWindow?.makeKeyAndVisible()
    }

    func hide() {
        toastWindow?.isHidden = true
        toastWindow?.rootViewController = nil
        toastWindow?.resignKey()
    }
}
