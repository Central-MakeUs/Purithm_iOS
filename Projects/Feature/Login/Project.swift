//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 이숭인 on 7/16/24.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeFeatureModule(
    .login,
    dependencies: [
        .core(.auth),
        .core(.common),
        .thirdParty(.snapKit),
        .thirdParty(.then),
        .thirdParty(.combineCocoa),
        .thirdParty(.combineExt),
        .thirdParty(.rxSwift)
    ]
)

