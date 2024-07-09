//
//  Project+Templates.swift
//  PurithmManifests
//
//  Created by 이숭인 on 7/8/24.
//

import ProjectDescription

//MARK: - Main
extension Project {
    public static let deployTarget = 16.0
    public static let bundleID = "com.purithm"
    
    public static func makeMainApp(
        appName: String,
        dependencies: [TargetDependency] = []
    ) -> Project {
        return Project(
            name: appName,
            settings: .defaultWithCodeSign(),
            targets: [
                makeTarget(
                    name: appName,
                    product: .app,
                    bundleID: "\(bundleID).app",
                    infoPlist: .default,
//                    infoPlist: .file(path: "Sources/Info.plist"),
                    hasResource: true,
                    dependencies: dependencies
                ),
                makeTarget(
                    name: "\(appName)Tests",
                    product: .unitTests,
                    bundleID: "\(bundleID).app.tests",
                    dependencies: [.target(name: "\(appName)")]
                )
            ],
            resourceSynthesizers: [
                .assets()
            ]
        )
    }
}

//MARK: - Feature
extension Project {
    public static func makeFeatureModule(
        _ target: Module.Feature,
        dependencies: [TargetDependency] = []
    ) -> Project {
        let name = target.rawValue
        return Project(
            name: name,
            settings: .settings(defaultSettings: .recommended),
            targets: [
                makeTarget(
                    name: "\(name)",
                    product: .framework,
                    bundleID: "\(bundleID).\(name).feature",
                    infoPlist: target == .auth ? makeAuthModuleInfoPlist() : .default,
                    dependencies: dependencies
                )
            ]
        )
    }
    
    public static func makeExampleModule(
        appName: String,
        dependencies: [TargetDependency] = []
    ) -> Project {
        return Project(
            name: appName,
            settings: .defaultWithCodeSign(),
            targets: [
                makeTarget(
                    name: "\(appName)Example",
                    product: .app,
                    bundleID: "\(bundleID).\(appName).example",
                    infoPlist: .default,
                    hasResource: true,
                    dependencies: dependencies
                )
            ],
            resourceSynthesizers: [
                .assets()
            ]
        )
    }
}

//MARK: - Core
extension Project {
    public static func makeCoreModule(
        _ target: Module.Core,
        dependencies: [TargetDependency] = []
    ) -> Project {
        let name = target.rawValue
        return Project(
            name: "\(name)",
            settings: .settings(defaultSettings: .recommended),
            targets: [
                makeTarget(
                    name: "\(name)Core",
                    product: .framework,
                    bundleID: "\(bundleID).\(name).core",
                    dependencies: dependencies
                ),
            ]
        )
    }
}

// MARK: - Target
extension Project {
    static func makeTarget(
        name: String,
        product: Product,
        bundleID: String,
        infoPlist: InfoPlist? = .default,
        hasResource: Bool = false,
        dependencies: [TargetDependency] = []
    ) -> Target {
        return .target(
            name: name,
            destinations: [.iPhone],
            product: product,
            bundleId: bundleID,
            deploymentTargets: .iOS("\(Project.deployTarget)"),
            infoPlist: infoPlist,
            sources: ["Sources/**"],
            resources: hasResource ? ["Resources/**"] : nil,
            dependencies: dependencies
        )
    }
}
