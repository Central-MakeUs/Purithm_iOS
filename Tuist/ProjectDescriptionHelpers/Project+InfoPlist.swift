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
                    "CFBundleURLSchemes": [ "kakao0d6fbb90fdd3615fa419c28d59c290b7" ]
                ]
            ]
        ]
        
        return InfoPlist.extendingDefault(with: infoPlist)
    }
}
