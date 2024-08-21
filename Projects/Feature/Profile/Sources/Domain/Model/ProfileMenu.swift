//
//  ProfileMenu.swift
//  Profile
//
//  Created by 이숭인 on 8/21/24.
//

import UIKit
import CoreCommonKit

enum ProfileMenu: String, CaseIterable {
    case wishlist
    case filterViewHistory
    case writtenReviews
    
    var identifier: String {
        return self.rawValue
    }
    
    var title: String {
          switch self {
          case .wishlist:
              return "찜 목록"
          case .filterViewHistory:
              return "필터 열람 내역"
          case .writtenReviews:
              return "남긴 후기"
          }
      }
    
    var leftImage: UIImage {
        switch self {
        case .wishlist:
            return UIImage.icLikeUnpressed
        case .filterViewHistory:
            return UIImage.icHistory
        case .writtenReviews:
            return UIImage.icEdit
        }
    }
}
