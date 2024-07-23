//
//  TermsAndConditionsViewController.swift
//  Login
//
//  Created by 이숭인 on 7/17/24.
//

import UIKit
import SnapKit
import Then
import CoreUIKit
import CoreCommonKit

import Combine
import CombineCocoa

final class TermsAndConditionsViewController: ViewController<TermsAndConditionsView> {
    let viewModel: TermsAndConditionsViewModel
    private var cancellables = Set<AnyCancellable>()
    
    private lazy var adapter = CollectionViewAdapter(with: contentView.collectionView)
    
    init(viewModel: TermsAndConditionsViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationItem.title = "이용약관"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray100
        
        bindViewModel()
        bindAdapter()
        bindAction()
    }
    
    private func bindAdapter() {
//        adapter.didSelectItemPublisher
//            .receive(on: DispatchQueue.main)
//            .sink { [weak self] itemModel in
//                //TODO: isSelected Upadate
//                itemModel.identifier
//            }
//            .store(in: &cancellables)
    }
    
    private func bindViewModel() {
        let input = TermsAndConditionsViewModel.Input(
            termsButtonDidTapEvent: adapter.didSelectItemPublisher
        )
        
        let output = viewModel.transform(input: input)
        
        output.sectionItems
            .sink { [weak self] sections in
                _ = self?.adapter.receive(sections)
            }
            .store(in: &cancellables)
    }
    
    private func bindAction() {
        contentView.agreeButton.tapPublisher
            .sink { [weak self] _ in
                self?.viewModel.testFinish()
            }
            .store(in: &cancellables)
    }
}


