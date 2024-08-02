//
//  FiltersViewController.swift
//  Filter
//
//  Created by 이숭인 on 7/26/24.
//

import UIKit
import CoreUIKit
import CoreCommonKit

import Combine

public final class FiltersViewController: ViewController<FiltersView> {
    var cancellables = Set<AnyCancellable>()
    
    let viewModel: FiltersViewModel
    private lazy var adapter = CollectionViewAdapter(with: contentView.filterCollectionView)
    
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
    }
    
    private func bindViewModel() {
        let input = FiltersViewModel.Input(
            viewWillAppearEvent: rx.viewWillAppear.asPublisher(),
            chipDidTapEvent: adapter.didSelectItemPublisher,
            orderOptionTapEvent: adapter.actionEventPublisher
        )
        let output = viewModel.transform(input: input)
        
        output.sectionItems
            .receive(on: DispatchQueue.main)
            .sink { [weak self] sections in
                _ = self?.adapter.receive(sections)
            }
            .store(in: &cancellables)
    }
}
