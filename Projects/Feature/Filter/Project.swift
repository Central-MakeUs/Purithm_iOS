//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 이숭인 on 7/8/24.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeFeatureModule(
    .filter,
    dependencies: [
        .feature(.review),
        .core(.common),
        .core(.uiKit),
        .thirdParty(.snapKit),
        .thirdParty(.then),
        .thirdParty(.rxSwift),
        .thirdParty(.combineExt),
        .thirdParty(.combineCocoa),
        .thirdParty(.kingfisher)
    ]
)

