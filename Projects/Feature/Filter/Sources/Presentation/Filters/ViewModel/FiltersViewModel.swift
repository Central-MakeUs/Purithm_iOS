//
//  FiltersViewModel.swift
//  Filter
//
//  Created by 이숭인 on 7/28/24.
//

import Foundation
import Combine
import CoreUIKit

public enum FilterChipType: String, CaseIterable {
    case one = "몽환적인"
    case two = "뉴진스"
    case three = "보랏빛"
    case four = "역광에서"
    case five
    case six
    case seven
    
    var title: String {
        return self.rawValue
    }
    
    var identifier: String {
        return self.rawValue
    }
}

public enum FilterOrderOptionType: String, CaseIterable {
    case popularity
    case latest
    case pureIndexHigh
    
    var identifier: String {
        return self.rawValue
    }
    
    var title: String {
        switch self {
        case .popularity:
            return "인기순"
        case .latest:
            return "최신순"
        case .pureIndexHigh:
            return "퓨어지수 높은순"
        }
    }
}

extension FiltersViewModel {
    struct Input {
        let viewWillAppearEvent: AnyPublisher<Bool, Never>
        let chipDidTapEvent: AnyPublisher<ItemModelType, Never>
        let orderOptionTapEvent: AnyPublisher<ActionEventItem, Never>
    }
    
    struct Output {
        let sectionItems = CurrentValueSubject<[SectionModelType], Never>([])
    }
}

public final class FiltersViewModel {
    private var cancellabels = Set<AnyCancellable>()
    
    weak var coordinator: FiltersCoordinatorable?
    private let sectionConverter = FiltersViewSectionConverter()
    
    private var chipModels: [FilterChipModel] = []
    private var orderOption: FilterOrderOptionType = .popularity
    private var filters: [FilterItemModel] = [
        FilterItemModel(
            identifier: UUID().uuidString,
            filterImageURLString: "https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0",
            planType: .premiumPlus,
            filterTitle: "Rainbow",
            author: "Made by Ehwa",
            isLike: true,
            likeCount: 12
        ),
        FilterItemModel(
            identifier: UUID().uuidString,
            filterImageURLString: "https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0",
            planType: .premium,
            filterTitle: "Blueming",
            author: "Made by Ehwa",
            isLike: false,
            likeCount: 12
        ),
        FilterItemModel(
            identifier: UUID().uuidString,
            filterImageURLString: "https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0",
            planType: .free,
            filterTitle: "title",
            author: "author",
            isLike: false,
            likeCount: 12
        ),
        FilterItemModel(
            identifier: UUID().uuidString,
            filterImageURLString: "https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0",
            planType: .free,
            filterTitle: "title",
            author: "author",
            isLike: false,
            likeCount: 12
        ),
        FilterItemModel(
            identifier: UUID().uuidString,
            filterImageURLString: "",
            planType: .free,
            filterTitle: "title",
            author: "author",
            isLike: false,
            likeCount: 12
        ),
        FilterItemModel(
            identifier: UUID().uuidString,
            filterImageURLString: "",
            planType: .free,
            filterTitle: "title",
            author: "author",
            isLike: false,
            likeCount: 12
        ),
        FilterItemModel(
            identifier: UUID().uuidString,
            filterImageURLString: "",
            planType: .free,
            filterTitle: "title",
            author: "author",
            isLike: false,
            likeCount: 12
        ),
        FilterItemModel(
            identifier: UUID().uuidString,
            filterImageURLString: "",
            planType: .free,
            filterTitle: "title",
            author: "author",
            isLike: false,
            likeCount: 12
        ),
        FilterItemModel(
            identifier: UUID().uuidString,
            filterImageURLString: "",
            planType: .free,
            filterTitle: "title",
            author: "author",
            isLike: false,
            likeCount: 12
        ),
    ]
    
    public init(coordinator: FiltersCoordinatorable) {
        self.coordinator = coordinator
    }
    
    func transform(input: Input) -> Output {
        let output = Output()
        
        handleViewWillAppearEvent(input: input, output: output)
        handleChipDidTapEvent(input: input, output: output)
        handleOrderOptionTapEvent(input: input, output: output)
        
        return output
    }
}

//MARK: - Private Functions
extension FiltersViewModel {
    private func handleViewWillAppearEvent(input: Input, output: Output) {
        input.viewWillAppearEvent
            .first()
            .sink { [weak self] _ in
                let chips = FilterChipType.allCases.map { type in
                    FilterChipModel(
                        identifier: type.rawValue,
                        title: type.title,
                        isSelected: type == .one ? true : false,
                        chipType: type
                    )
                }
                self?.chipModels = chips
                
                guard let sections = self?.sectionConverter.createSections(
                    chips: chips,
                    orderOption: self?.orderOption ?? .popularity,
                    filters: self?.filters ?? []
                ) else {
                    return
                }
                output.sectionItems.send(sections)
            }
            .store(in: &cancellabels)
    }
    
    private func handleChipDidTapEvent(input: Input, output: Output) {
        input.chipDidTapEvent
            .receive(on: DispatchQueue.main)
            .sink { [weak self] itemModel in
                guard let self else { return }
                
                if let targetIndex = self.chipModels.firstIndex(where: { $0.identifier == itemModel.identifier }) {
                    for index in self.chipModels.indices {
                        self.chipModels[index].isSelected = false
                    }
                    self.chipModels[targetIndex].isSelected.toggle()
                }
                
                let sections = self.sectionConverter.createSections(
                    chips: self.chipModels,
                    orderOption: self.orderOption,
                    filters: self.filters
                )
                
                output.sectionItems.send(sections)
            }
            .store(in: &cancellabels)
    }
    
    private func handleOrderOptionTapEvent(input: Input, output: Output) {
        input.orderOptionTapEvent
            .sink { [weak self] actionItem in
                guard let self else { return }
                
                switch actionItem {
                case let action as FilterOrderOptionAction:
                    print("::: order")
                case let action as FilterLikeAction:
                    if let targetIndex = self.filters.firstIndex(where: { $0.identifier == action.identifier }) {
                        self.filters[targetIndex].isLike.toggle()
                    }
                    let sections = self.sectionConverter.createSections(
                        chips: self.chipModels,
                        orderOption: self.orderOption,
                        filters: self.filters
                    )
                    
                    output.sectionItems.send(sections)
                case let action as FilterDidTapAction:
                    DispatchQueue.main.async {
                        self.coordinator?.pushFilterDetail(with: action.identifier)
                    }
                default:
                    print("invalid action type > \(actionItem)")
                    break
                }
            }
            .store(in: &cancellabels)
    }
}
