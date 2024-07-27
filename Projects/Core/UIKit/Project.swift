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
        .core(.common),
        .thirdParty(.snapKit),
        .thirdParty(.then),
        .thirdParty(.combineCocoa),
        .thirdParty(.rxSwift),
        .thirdParty(.rxCocoa),
    ]
)
