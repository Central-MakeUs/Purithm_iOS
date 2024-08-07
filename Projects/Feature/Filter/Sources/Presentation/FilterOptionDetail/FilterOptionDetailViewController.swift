//
//  FilterOptionDetailViewController.swift
//  Filter
//
//  Created by 이숭인 on 8/6/24.
//

import UIKit
import CoreUIKit
import Combine

final class FilterOptionDetailViewController: ViewController<FilterOptionDetailView> {
    private let viewModel: FilterOptionDetailViewModel
    private lazy var adapter = CollectionViewAdapter(with: contentView.collectionView)
    
    var cancellables = Set<AnyCancellable>()
    
    init(viewModel: FilterOptionDetailViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentView.configure(
            with: .close(title: "Blueming", isLike: true),
            imageURLString: "https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0"
        )
        bindViewModel()
    }
    
    private func bindViewModel() {
        let input = FilterOptionDetailViewModel.Input(
            closeButtonTapEvent: contentView.backButtonTapEvent,
            likeButtonTapEvent: contentView.likeButtonTapEvent
        )
        
        let output = viewModel.transform(input: input)
        
        output.sections
            .sink { [weak self] sections in
                _ = self?.adapter.receive(sections)
            }
            .store(in: &cancellables)
            
        contentView.helpOptionTapEvent
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.presentScrollableBottomSheet()
            }
            .store(in: &cancellables)
    }
}

extension FilterOptionDetailViewController {
    private func presentScrollableBottomSheet() {
        let bottomSheetVC = PurithmOptionHelpBottomSheet()
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

