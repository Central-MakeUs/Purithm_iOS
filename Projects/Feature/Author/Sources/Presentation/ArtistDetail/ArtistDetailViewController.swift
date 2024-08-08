//
//  ArtistDetailViewController.swift
//  Author
//
//  Created by 이숭인 on 8/9/24.
//

import UIKit
import Combine
import CoreUIKit
import CoreCommonKit

final class ArtistDetailViewController: ViewController<ArtistDetailView> {
    let viewModel: ArtistDetailViewModel
    
    init(viewModel: ArtistDetailViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initNavigationBar(with: .page)
    }
}

extension ArtistDetailViewController: NavigationBarApplicable {
    var leftButtonItems: [NavigationBarButtonItemType] {
        return [
            .backImage(
                identifier: "left_back_bar_button",
                image: .icArrowLeft,
                color: .gray500
            )
        ]
    }
}
