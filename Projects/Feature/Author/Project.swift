//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 이숭인 on 7/8/24.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeFeatureModule(
    .author,
    dependencies: [
        .feature(.filter),
        .core(.common),
        .core(.uiKit),
        .thirdParty(.snapKit),
        .thirdParty(.then),
        .thirdParty(.kingfisher),
        .thirdParty(.rxSwift),
        .thirdParty(.combineExt),
        .thirdParty(.combineCocoa)
    ]
)
