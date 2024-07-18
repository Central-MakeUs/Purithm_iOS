//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 이숭인 on 7/18/24.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeCoreModule(
    .listKit,
    dependencies: [
        .thirdParty(.rxSwift),
        .thirdParty(.rxSwiftExt),
        .thirdParty(.combineCocoa)
    ]
)

