//
//  FilterReviewsViewController.swift
//  Filter
//
//  Created by 이숭인 on 8/5/24.
//

import UIKit
import CoreUIKit
import Combine

final class FilterReviewsViewController: ViewController<FilterReviews> {
    private let viewModel: FilterReviewsViewModel
    
    init(viewModel: FilterReviewsViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
