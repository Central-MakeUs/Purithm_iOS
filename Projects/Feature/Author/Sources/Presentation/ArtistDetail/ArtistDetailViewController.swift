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
    private var cancellables = Set<AnyCancellable>()
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
    }
    
    private func bindViewModel() {
        let input = ArtistDetailViewModel.Input(
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
                //TODO: 바텀시트
                print("//TODO: 바텀시트")
            }
            .store(in: &cancellables)
    }
}

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
