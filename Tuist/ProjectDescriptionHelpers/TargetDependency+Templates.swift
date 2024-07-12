//
//  TargetDependency+Templates.swift
//  PurithmManifests
//
//  Created by 이숭인 on 7/8/24.
//

import ProjectDescription

// feature
// interface
// example


public extension TargetDependency {
    static func feature(
        _ target: Module.Feature
    ) -> TargetDependency {
        return .project(
            target: "\(target.rawValue)",
            path: .relativeToRoot("Projects/Feature/\(target.rawValue)")
        )
    }
    
    static func core(
        _ target: Module.Core
    ) -> TargetDependency {
        return .project(
            target: "Core\(target.rawValue)",
            path: .relativeToRoot("Projects/Core/\(target.rawValue)")
        )
    }
    
//    static func network(
//        _ target: Module.Network
//    ) -> TargetDependency {
//        return .project(
//            target: "\(target.rawValue)Network",
//            path: .relativeToRoot("Projects/Network/\(target.rawValue)")
//        )
//    }
//    
//    static func database(
//        _ target: Module.Database
//    ) -> TargetDependency {
//        return .project(
//            target: "\(target.rawValue)Database",
//            path: .relativeToRoot("Projects/Database/\(target.rawValue)")
//        )
//    }
    
    static func thirdParty(
        _ target: Module.ThirdParty,
        condition: PlatformCondition? = nil
    ) -> TargetDependency {
        return .external(name: "\(target.rawValue)", condition: condition)
    }
}
