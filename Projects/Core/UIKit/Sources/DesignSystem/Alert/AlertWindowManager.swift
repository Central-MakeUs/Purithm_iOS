//
//  AlertWindowManager.swift
//  CoreUIKit
//
//  Created by 이숭인 on 7/26/24.
//

import UIKit

public class AlertWindowManager {
    static var shared = AlertWindowManager()

    var alertWindow: AlertWindow?

    private init() {
        let windowScene = UIApplication.shared
            .connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .first
        if let windowScene = windowScene as? UIWindowScene {
            alertWindow = AlertWindow(windowScene: windowScene)
        }
    }

    func show() {
        alertWindow?.isHidden = false
        alertWindow?.rootViewController = UIViewController()
        alertWindow?.makeKeyAndVisible()
    }

    func hide() {
        alertWindow?.isHidden = true
        alertWindow?.rootViewController = nil
        alertWindow?.resignKey()
    }
}
