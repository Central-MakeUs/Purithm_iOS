//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 이숭인 on 7/8/24.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeFeatureModule(
    .auth,
    dependencies: [
        .core(.network),
        .thirdParty(.rxSwift),
        .thirdParty(.rxKakaoSDK)
    ]
)

