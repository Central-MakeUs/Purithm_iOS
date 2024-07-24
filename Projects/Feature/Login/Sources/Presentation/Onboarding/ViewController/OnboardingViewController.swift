//
//  OnboardingViewController.swift
//  Login
//
//  Created by 이숭인 on 7/24/24.
//

import UIKit
import CoreCommonKit
import CoreUIKit

final class OnboardingViewController: ViewController<OnboardingView> {
    init(image: UIImage, title: String, subTitle: String){
        super.init()
        contentView.configure(
            image: image,
            title: title,
            subTitle: subTitle
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

