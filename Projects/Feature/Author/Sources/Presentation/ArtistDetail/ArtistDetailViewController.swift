//
//  ArtistDetailViewController.swift
//  Author
//
//  Created by 이숭인 on 8/9/24.
//

import UIKit
import Combine
import CoreUIKit
import CoreCommonKit

final class ArtistDetailViewController: ViewController<ArtistDetailView> {
    var cancellables = Set<AnyCancellable>()
    let viewModel: ArtistDetailViewModel
    
    private lazy var adapter = CollectionViewAdapter(with: contentView.collectionView)
    
    init(viewModel: ArtistDetailViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initNavigationBar(with: .page)
        
        bindViewModel()
        bindErrorHandler()
    }
    
    private func bindViewModel() {
        let input = ArtistDetailViewModel.Input(
            viewWillAppearEvent: rx.viewWillAppear.asPublisher(),
            adapterActionEvent: adapter.actionEventPublisher,
            adapterWillDisplayCellEvent: adapter.willDisplayCellPublisher
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
        
        output.presentFilterRockBottomSheetEvent
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.presentContentBottomSheet()
            }
            .store(in: &cancellables)
    }
}

//MARK: - BottomSheet
extension ArtistDetailViewController {
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
}

//MARK: - Navigation
extension ArtistDetailViewController: NavigationBarApplicable {
    var leftButtonItems: [NavigationBarButtonItemType] {
        return [
            .backImage(
                identifier: "left_back_bar_button",
                image: .icArrowLeft,
                color: .gray500
            )
        ]
    }
}
