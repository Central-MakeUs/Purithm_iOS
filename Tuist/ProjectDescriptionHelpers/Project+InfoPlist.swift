//
//  Project+InfoPlist.swift
//  PurithmManifests
//
//  Created by 이숭인 on 7/8/24.
//

import ProjectDescription

extension Project {
    static func makeMainInfoPlist() -> InfoPlist {
        .default
    }
    
    static func makeAuthModuleInfoPlist() -> InfoPlist {
        //TODO: 아래 kakao url scheme 정보는 별도로 관리할 예정
        let infoPlist: [String: Plist.Value] = [
            "LSApplicationQueriesSchemes": [ "kakaokompassauth" ],
            "CFBundleURLTypes": [
                [
                    "CFBundleURLSchemes": [ "kakaoc6e355b541377b0886d546a44fc76f50" ]
                ]
            ]
        ]
        
        return InfoPlist.extendingDefault(with: infoPlist)
    }
    
    static func makeDefaultInfoPlist() -> InfoPlist {
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
