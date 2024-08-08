//
//  ReviewViewController.swift
//  Review
//
//  Created by 이숭인 on 8/9/24.
//

import UIKit
import CoreUIKit
import CoreCommonKit
import Combine

extension ReviewViewController {
    private enum Constants {
        static let backImageIdentifier = "left_back_bar_button"
        static let questionImageIdentifier = "right_question_bar_button"
    }
}

public final class ReviewViewController: ViewController<ReviewView> {
    private let viewModel: ReviewViewModel
    
    public init(viewModel: ReviewViewModel) {
        self.viewModel = viewModel
        super.init()
        
        initNavigationBar(with: .page)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - BottomSheet
extension ReviewViewController {
    private func presentContentBottomSheet() {
        let bottomSheetVC = PurithmContentBottomSheet()
        bottomSheetVC.contentModel = PurithmContentModel(
            contentType: .satisfaction,
            title: "필터 만족도",
            description: "퓨어지수는 퓨리즘만의 별점 시스템입니다. 구매 만족도가 높을수록 100%에 가까워요."
        )
        
        if let sheet = bottomSheetVC.sheetPresentationController {
            sheet.detents = [.custom(resolver: { context in
                return bottomSheetVC.preferredContentSize.height
            })]
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 16.0
        }
        
        self.present(bottomSheetVC, animated: true, completion: nil)
    }
}

//MARK: - Navigation
extension ReviewViewController: NavigationBarApplicable {
    public func handleNavigationButtonAction(with identifier: String) {
        switch identifier {
        case Constants.questionImageIdentifier:
            presentContentBottomSheet()
        default:
            break
        }
    }
    
    public var leftButtonItems: [NavigationBarButtonItemType] {
        return [
            .backImage(
                identifier: Constants.backImageIdentifier,
                image: .icArrowLeft,
                color: .gray500
            )
        ]
    }
    
    public var rightButtonItems: [NavigationBarButtonItemType] {
        return [
            .image(
                identifier: Constants.questionImageIdentifier,
                image: .icQuestion,
                color: .gray500
            )
        ]
    }
}
