//
//  TermsAndConditionsViewController.swift
//  Purithm
//
//  Created by 이숭인 on 7/14/24.
//

import UIKit
import SnapKit
import Then

import Combine
import CombineCocoa


final class TermsAndConditionsViewController: UIViewController {
    private let label = UILabel().then {
        $0.text = "이용약관"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        navigationItem.hidesBackButton = true
        
        setupSubviews()
        setupConstraints()
    }
 
    private func setupSubviews() {
        view.addSubview(label)
    }
        
    private func setupConstraints() {
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
