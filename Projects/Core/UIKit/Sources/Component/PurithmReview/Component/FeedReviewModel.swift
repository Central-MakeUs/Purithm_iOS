//
//  FeedReviewModel.swift
//  CoreUIKit
//
//  Created by 이숭인 on 8/8/24.
//

import Foundation
import CoreCommonKit

public struct FeedReviewModel {
    public var identifier: String
    public let imageURLStrings: [String]
    public let author: String
    public let authorProfileURL: String
    public let satisfactionValue: Int
    public let satisfactionLevel: SatisfactionLevel
    public let content: String
    public let feedID: String
    
    public init(
        identifier: String,
        imageURLStrings: [String],
        author: String,
        authorProfileURL: String,
        satisfactionValue: Int,
        satisfactionLevel: SatisfactionLevel,
        content: String,
        feedID: String = ""
    ) {
        self.identifier = identifier
        self.imageURLStrings = imageURLStrings
        self.author = author
        self.authorProfileURL = authorProfileURL
        self.satisfactionValue = satisfactionValue
        self.satisfactionLevel = satisfactionLevel
        self.content = content
        self.feedID = feedID
    }
}
