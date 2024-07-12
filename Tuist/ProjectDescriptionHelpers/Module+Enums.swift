//
//  Module+Enums.swift
//  PurithmManifests
//
//  Created by 이숭인 on 7/8/24.
//

import Foundation

public enum Module {
    public enum Feature: String, CaseIterable {
        case auth = "Auth"
        case filter = "Filter"
        case author = "Author"
        case payment = "Payment"
        case profile = "Profile"
        case feed = "Feed"
        case like = "Like"
    }
    
    public enum Core: String, CaseIterable {
        case cache = "Cache"
        case network = "Network"
        case keychain = "Keychain"
    }
    
    public enum ThirdParty: String {
        case snapKit = "SnapKit"
        case then = "Then"
        case alamofire = "Alamofire"
        case realm = "RealmSwift"
        case combineExt = "CombineExt"
        case combineCocoa = "CombineCocoa"
        case rxSwift = "RxSwift"
        case rxSwiftExt = "RxSwiftExt"
        
        case rxKakaoSDK = "RxKakaoSDK"
    }
}
