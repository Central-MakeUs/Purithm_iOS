//
//  TermsAndConditionsViewController.swift
//  Login
//
//  Created by 이숭인 on 7/17/24.
//

import UIKit
import SnapKit
import Then

import Combine
import CombineCocoa

final class TermsAndConditionsViewController: UIViewController {
    let viewModel: TermsAndConditionsViewModel
    private var cancellables = Set<AnyCancellable>()
    
    private let label = UILabel().then {
        $0.text = "이용약관"
    }
    
    private let button = UIButton().then {
        $0.setTitle("누르면 동의", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .systemBlue
    }
    
    init(viewModel: TermsAndConditionsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        navigationItem.hidesBackButton = true
        
        setupSubviews()
        setupConstraints()
        bindAction()
    }
 
    private func setupSubviews() {
        view.addSubview(label)
        view.addSubview(button)
    }
        
    private func setupConstraints() {
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        button.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom)
            make.width.equalTo(120)
            make.height.equalTo(42)
        }
    }
    
    private func bindAction() {
        button.tapPublisher
            .sink { [weak self] _ in
                self?.viewModel.testFinish()
            }
            .store(in: &cancellables)
    }
}


