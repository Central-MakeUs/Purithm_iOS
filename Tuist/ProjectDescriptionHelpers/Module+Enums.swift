//
//  Module+Enums.swift
//  PurithmManifests
//
//  Created by 이숭인 on 7/8/24.
//

import ProjectDescription

public enum Module {
    public enum Feature: String, CaseIterable {
        case login = "Login"
        case filter = "Filter"
        case author = "Author"
        case payment = "Payment"
        case profile = "Profile"
        case feed = "Feed"
        case like = "Like"
        case review = "Review"
    }
    
    public enum Core: String, CaseIterable {
        case cache = "Cache"
        case network = "Network"
        case keychain = "Keychain"
        case auth = "PurithmAuth"
        case uiKit = "UIKit"
        case common = "CommonKit"
        
        
        func makeInfoPlist() -> InfoPlist {
            switch self {
            case .auth:
                return makeAuthModuleInfoPlist()
            case .common:
                return makeCommonModuleInfoPlist()
            default:
                return makeDefaultInfoPlist()
            }
        }
        private func makeAuthModuleInfoPlist() -> InfoPlist {
            //TODO: 아래 kakao url scheme 정보는 별도로 관리할 예정
            let infoPlist: [String: Plist.Value] = [
                "LSApplicationQueriesSchemes": [ "kakaokompassauth" , "kakaotalk"],
                "CFBundleURLTypes": [
                    [
                        "CFBundleURLSchemes": [ "kakaoc6e355b541377b0886d546a44fc76f50" ]
                    ]
                ]
            ]
            
            return InfoPlist.extendingDefault(with: infoPlist)
        }
        
        private func makeCommonModuleInfoPlist() -> InfoPlist {
            let infoPlist: InfoPlist = .extendingDefault(with: [
                "UIAppFonts": [
                    "Pretendard-Medium.otf",
                    "Pretendard-SemiBold.otf",
                    "EBGaramond-Medium.ttf",
                    "EBGaramond-SemiBold.ttf"
                ]])
            
            return infoPlist
        }
        
        private func makeDefaultInfoPlist() -> InfoPlist {
            let infoPlist: [String: Plist.Value] = [
                "NSAppTransportSecurity": [
                    "NSAllowsArbitraryLoads": true,
                    "NSAllowsArbitraryLoadsInWebContent": true,
                    "NSAllowsLocalNetworking": true
                ],
                
            ]
            
            return InfoPlist.extendingDefault(with: infoPlist)
        }
    }
    
    public enum ThirdParty: String {
        case snapKit = "SnapKit"
        case then = "Then"
        case alamofire = "Alamofire"
        case realm = "RealmSwift"
        case combineExt = "CombineExt"
        case combineCocoa = "CombineCocoa"
        case rxSwift = "RxSwift"
        case rxCocoa = "RxCocoa"
        case rxSwiftExt = "RxSwiftExt"
        case rxKakaoSDK = "RxKakaoSDK"
        case kingfisher = "Kingfisher"
        case moya = "Moya"
        case combineMoya = "CombineMoya"
    }
}
