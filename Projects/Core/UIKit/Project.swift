//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 이숭인 on 7/16/24.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeCoreModule(
    .uiKit,
    dependencies: [
        .thirdParty(.combineCocoa),
        .thirdParty(.rxSwift)
    ]
)
