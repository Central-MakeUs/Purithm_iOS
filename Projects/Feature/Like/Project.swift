//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 이숭인 on 7/8/24.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeFeatureModule(
    .like,
    dependencies: [
        .thirdParty(.rxSwift),
        .thirdParty(.combineExt),
        .thirdParty(.combineCocoa)
    ]
)

