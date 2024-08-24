//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 이숭인 on 7/8/24.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeFeatureModule(
    .profile,
    dependencies: [
        .core(.common),
        .core(.uiKit),
        .core(.keychain),
        .feature(.filter),
        .feature(.review),
        .thirdParty(.snapKit),
        .thirdParty(.then),
        .thirdParty(.kingfisher),
        .thirdParty(.rxSwift),
        .thirdParty(.combineExt),
        .thirdParty(.combineCocoa)
    ]
)
