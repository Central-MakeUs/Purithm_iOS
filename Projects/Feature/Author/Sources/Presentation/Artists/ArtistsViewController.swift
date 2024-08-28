//
//  ArtistsViewController.swift
//  Author
//
//  Created by 이숭인 on 8/8/24.
//

import UIKit
import CoreUIKit
import CoreCommonKit
import SnapKit
import Then
import Combine

final class ArtistsViewController: ViewController<ArtistsView> {
    var cancellables = Set<AnyCancellable>()
    let viewModel: ArtistsViewModel
    
    private lazy var adapter = CollectionViewAdapter(with: contentView.collectionView)
    
    init(viewModel: ArtistsViewModel) {
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
        let input = ArtistsViewModel.Input(
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
        
        output.sectionEmptyPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isEmpty in
                self?.contentView.showEmptyViewIfNeeded(with: isEmpty)
            }
            .store(in: &cancellables)
        
        viewModel.firstLoadingStatePublisher
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                self?.contentView.showLoadingViewInNeeded(with: isLoading)
            }
            .store(in: &cancellables)
    }
}

extension ArtistsViewController {
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
