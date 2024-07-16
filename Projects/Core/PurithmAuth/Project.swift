//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 이숭인 on 7/8/24.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeCoreModule(
    .auth,
    dependencies: [
        .core(.network),
        .core(.keychain),
        .thirdParty(.combineExt),
        .thirdParty(.rxSwift),
        .thirdParty(.rxKakaoSDK)
    ]
)


