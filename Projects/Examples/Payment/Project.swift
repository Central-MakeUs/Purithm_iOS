//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 이숭인 on 7/9/24.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeExampleModule(
    appName: "Payment",
    dependencies: [
        .feature(.payment),
        .thirdParty(.snapKit),
        .thirdParty(.then),
        .thirdParty(.combineCocoa),
        .thirdParty(.combineExt),
        .thirdParty(.rxSwift)
    ]
)
