//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 이숭인 on 7/8/24.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeMainApp(
    appName: "Purithm",
    dependencies: [
        .core(.network),
        .feature(.login),
        .feature(.filter),
        .feature(.feed),
        .feature(.author),
        .thirdParty(.snapKit),
        .thirdParty(.then),
        .thirdParty(.combineCocoa),
        .thirdParty(.combineExt),
        .thirdParty(.rxSwift),
        .thirdParty(.rxCocoa)
    ]
)

