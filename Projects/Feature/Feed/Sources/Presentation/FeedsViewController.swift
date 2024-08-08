//
//  FeedsViewController.swift
//  Feed
//
//  Created by 이숭인 on 8/8/24.
//

import UIKit
import CoreUIKit
import CoreCommonKit
import Combine
import SnapKit

final class FeedsViewController: ViewController<FeedsView> {
    var cancellables = Set<AnyCancellable>()
    let viewModel: FeedsViewModel
    
    private lazy var adapter = CollectionViewAdapter(with: contentView.collectionView)
    
    init(viewModel: FeedsViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        bindViewModel()
    }
    
    private func bindViewModel() {
        let input = FeedsViewModel.Input(
            viewWillAppearEvent: rx.viewWillAppear.asPublisher(),
            adapterActionEvent: adapter.actionEventPublisher
        )
        
        let output = viewModel.transform(input: input)
        
        output.sections
            .sink { [weak self] sections in
                _ = self?.adapter.receive(sections)
            }
            .store(in: &cancellables)
        
        output.presentOrderOptionBottomSheetEvent
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.presentMenuBottomSheet()
            }
            .store(in: &cancellables)
    }
}

extension FeedsViewController {
    private func presentMenuBottomSheet() {
        let bottomSheetVC = PurithmMenuBottomSheet()
        if let sheet = bottomSheetVC.sheetPresentationController {
            sheet.detents = [.custom(resolver: { context in
                return bottomSheetVC.preferredContentSize.height
            })]
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 16.0
        }
        
        
        bottomSheetVC.menus = viewModel.orderOptions.map { option in
            PurithmMenuModel(
                identifier: option.identifier,
                title: option.option.title,
                isSelected: option.isSelected
            )
        }
        
        bottomSheetVC.menuTapEvent
            .receive(on: DispatchQueue.main)
            .sink { [weak self] identifier in
                self?.viewModel.toggleSelectedOrderOption(target: identifier)
                
            }
            .store(in: &self.cancellables)
        
        self.present(bottomSheetVC, animated: true, completion: nil)
    }
}
