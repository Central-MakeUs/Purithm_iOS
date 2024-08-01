//
//  AppDelegate.swift
//  Purithm
//
//  Created by 이숭인 on 7/8/24.
//

import UIKit
import KakaoSDKCommon
import KakaoSDKAuth
import AuthenticationServices
import CoreUIKit

import Login

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var appCoordinator: AppCoordinator?
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        //TODO: PurithmAuth Module로 옮겨야할듯
        KakaoSDK.initSDK(appKey: "0d6fbb90fdd3615fa419c28d59c290b7")
        UICollectionReusableView.swizzlePrepareForReuse()
        
        let navigationController = UINavigationController()
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
        
        self.appCoordinator = DefaultAppCoordinator(navigationController)
        self.appCoordinator?.start()
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        if (AuthApi.isKakaoTalkLoginUrl(url)) {
            return AuthController.rx.handleOpenUrl(url: url)
        }
        
        return false
    }
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        return true
    }
}
