//
//  PurithmContentModel.swift
//  CoreUIKit
//
//  Created by 이숭인 on 8/7/24.
//

import Foundation
import CoreCommonKit

public struct PurithmContentModel {
    let contentType: PurithmBottomSheetContentType
    let title: String
    let description: String
    
    public init(contentType: PurithmBottomSheetContentType, title: String, description: String) {
        self.contentType = contentType
        self.title = title
        self.description = description
    }
}
