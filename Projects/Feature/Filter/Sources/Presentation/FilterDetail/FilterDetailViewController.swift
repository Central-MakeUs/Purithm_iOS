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
        
        bindViewModel()
    }
    
    private func bindViewModel() {
        let input = FilterDetailViewModel.Input(
            viewWillAppearEvent: rx.viewWillAppear.asPublisher(),
            pageBackEvent: contentView.backButtonTapEvent,
            filterLikeEvent: contentView.likeButtonTapEvent,
            filterMoreOptionEvent: contentView.optionTapEvent,
            showOriginalTapEvent: contentView.originalTapEvent,
            showOriginalPressedEvent: contentView.originalPressedEvent,
            conformEvent: contentView.conformTapEvent
        )
        
        let output = viewModel.transform(input: input)
        
        output.headerInfo
            .receive(on: DispatchQueue.main)
            .sink { [weak self] detailModel in
                self?.contentView.configure(with:
                        .back(
                            title: detailModel.detailInformation.title,
                            likeCount: detailModel.detailInformation.likeCount,
                            isLike: detailModel.detailInformation.isLike
                        ), satisfaction: detailModel.detailInformation.satisfaction
                )
            }
            .store(in: &cancellables)
        
        output.sections
            .sink { [weak self] sections in
                _ = self?.adapter.receive(sections)
            }
            .store(in: &cancellables)
        
        contentView.textHideTapEvent
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.contentView.bottomView.showAndHide(with: 0.3)
            }
            .store(in: &cancellables)
        
        adapter.didScrollPublisher
            .receive(on: DispatchQueue.main)
            .debounce(for: .seconds(0.2), scheduler: RunLoop.main)
            .sink { [weak self] indexPath in
                guard let totalCount = self?.viewModel.filter?.detailImages.count, totalCount > 0 else {
                    return
                }
                
                self?.contentView.updatePageBadge(total: totalCount, current: indexPath.row)
            }
            .store(in: &cancellables)
    }
}
