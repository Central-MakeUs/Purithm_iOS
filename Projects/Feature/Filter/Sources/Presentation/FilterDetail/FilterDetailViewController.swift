//
//  FilterDetailViewController.swift
//  Filter
//
//  Created by 이숭인 on 7/30/24.
//

import UIKit
import CoreUIKit
import Combine
import RxSwift

final class FilterDetailViewController: ViewController<FilterDetailView> {
    private let viewModel: FilterDetailViewModel
    private var cancellables = Set<AnyCancellable>()
    
    private lazy var adapter = CollectionViewAdapter(with: contentView.collectionView)
    
    init(viewModel: FilterDetailViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentView.configure(title: "BlueMing", likeCount: 12, isLike: true)
        bindViewModel()
        
        contentView.backButtonTapEvent
            .sink { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }
            .store(in: &cancellables)
    }
    
    private func bindViewModel() {
        let input = FilterDetailViewModel.Input(
            viewWillAppearEvent: rx.viewWillAppear.asPublisher(),
            pageBackEvent: contentView.backButtonTapEvent,
            filterLikeEvent: contentView.likeButtonTapEvent,
            filterMoreOptionEvent: contentView.optionTapEvent,
            showOriginalEvent: contentView.originalTapEvent,
            conformEvent: contentView.conformTapEvent
        )
        
        let output = viewModel.transform(input: input)
        
        output.sections
            .sink { [weak self] sections in
                _ = self?.adapter.receive(sections)
            }
            .store(in: &cancellables)
        
        contentView.textHideTapEvent
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.contentView.bottomView.fadeInAndShow(with: 0.3)
            }
            .store(in: &cancellables)
        
        contentView.textHidePressedEvent
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.contentView.bottomView.fadeOutAndHide(with: 0.3)
            }
            .store(in: &cancellables)
    }
}
