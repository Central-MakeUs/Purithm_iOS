//
//  FiltersViewController.swift
//  Filter
//
//  Created by 이숭인 on 7/26/24.
//

import UIKit
import CoreUIKit
import CoreCommonKit
import SkeletonView
import Combine

public final class FiltersViewController: ViewController<FiltersView> {
    public var cancellables = Set<AnyCancellable>()
    
    let viewModel: FiltersViewModel
    private lazy var adapter = CollectionViewAdapter(with: contentView.filterCollectionView)
    private lazy var chipAdapter = CollectionViewAdapter(with: contentView.chipCollectionView)
    
    public init(viewModel: FiltersViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.extendedLayoutIncludesOpaqueBars = false
        
        bindViewModel()
        bindErrorHandler()
        
        contentView.configure(with: .none(title: "Filters"))
    }
    
    private func bindViewModel() {
        let input = FiltersViewModel.Input(
            viewWillAppearEvent: rx.viewWillAppear.asPublisher(),
            chipDidTapEvent: chipAdapter.didSelectItemPublisher,
            adapterItemTapEvent: adapter.actionEventPublisher,
            adapterWillDisplayCellEvent: adapter.willDisplayCellPublisher
        )
        
        
        let output = viewModel.transform(input: input)
        
        output.sections
            .receive(on: DispatchQueue.main)
            .sink { [weak self] sections in
                _ = self?.adapter.receive(sections)
            }
            .store(in: &cancellables)
        
        output.sectionEmptyPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isEmpty in
                self?.contentView.showEmptyViewIfNeeded(with: isEmpty)
            }
            .store(in: &cancellables)
        
        output.chipSections
            .receive(on: DispatchQueue.main)
            .sink { [weak self] sections in
                _ = self?.chipAdapter.receive(sections)
            }
            .store(in: &cancellables)
        
        output.presentOrderOptionBottomSheetEvent
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.presentMenuBottomSheet()
            }
            .store(in: &cancellables)
        
        output.presentFilterRockBottomSheetEvent
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.presentContentBottomSheet()
            }
            .store(in: &cancellables)
        
        viewModel.firstLoadingStatePublisher
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
//                self?.contentView.showSkeletonIfNeeded(with: isLoading)
            }
            .store(in: &cancellables)
    }
    
    private func presentContentBottomSheet() {
        let bottomSheetVC = PurithmContentBottomSheet()
        if let sheet = bottomSheetVC.sheetPresentationController {
            sheet.detents = [.custom(resolver: { context in
                return bottomSheetVC.preferredContentSize.height
            })]
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 16.0
        }
        
        bottomSheetVC.contentModel = PurithmContentModel(
            contentType: .premiumFilterLock,
            title: "잠금은 어떻게 푸나요?",
            description: "필터를 사용해보고 후기를 남기면 스탬프가 찍히고,\n일정 개수를 모으면 프리미엄 필터를 열람할 수 있어요."
        )
        
        self.present(bottomSheetVC, animated: true, completion: nil)
    }
    
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
