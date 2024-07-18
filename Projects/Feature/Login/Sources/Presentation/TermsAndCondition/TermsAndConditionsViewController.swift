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
import CoreListKit

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        bindViewModel()
        bindAdapter()
        bindAction()
    }
    
    private func bindAdapter() {
        adapter.didSelectItemPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] itemModel in
                
            }
            .store(in: &cancellables)
    }
    
    private func bindViewModel() {
        let output = viewModel.transform()
        
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


