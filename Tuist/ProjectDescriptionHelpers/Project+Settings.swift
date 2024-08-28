//
//  Project+Settings.swift
//  ProjectDescriptionHelpers
//
//  Created by 이숭인 on 7/8/24.
//

import ProjectDescription

extension Settings {
    public static func defaultWithCodeSign() -> Settings {
        return .settings(
            base: [
                "CODE_SIGN_IDENTITY": "Apple Development",
                "CODE_SIGN_ENTITLEMENTS": "$(SRCROOT)/Purithm.entitlements",
                
                "DEVELOPMENT_TEAM": "7W64WHVKVN",  // 팀 ID를 설정합니다.
                "CODE_SIGN_STYLE": "Automatic",
                "OTHER_LDFLAGS": "$(inherited) -ObjC"
            ]
        )
    }
}
