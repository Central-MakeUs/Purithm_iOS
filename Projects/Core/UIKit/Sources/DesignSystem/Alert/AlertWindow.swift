//
//  AlertWindow.swift
//  CoreUIKit
//
//  Created by 이숭인 on 7/26/24.
//

import UIKit

public class AlertWindow: UIWindow {
    public override init(windowScene: UIWindowScene) {
        super.init(windowScene: windowScene)
        setWindows()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setWindows() {
        windowLevel = UIWindow.Level.alert
        backgroundColor = .clear
        makeKeyAndVisible()
    }
}
