//
//  FilterDescriptionViewModel.swift
//  Filter
//
//  Created by 이숭인 on 8/3/24.
//

import Combine
import CoreUIKit

extension FilterDescriptionViewModel {
    struct Input {
        
    }
    
    struct Output {
        let descriptionsSubject = CurrentValueSubject<[FilterDescriptionModel], Never>([])
        var descriptions: AnyPublisher<[FilterDescriptionModel], Never> {
            descriptionsSubject.compactMap { $0 }.eraseToAnyPublisher()
        }
    }
}

final class FilterDescriptionViewModel {
    var descriptions: [FilterDescriptionModel] = [
        FilterDescriptionModel(
            type: .header,
            headerTitle: "Ehwa",
            contentImageURLString: "https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0",
            contentTitle: "노을바다",
            contentDescription: "안녕하세요! 여름을 맞아 에메랄드빛 바다가 생각나는 청량한 필터를 준비했어요. 모래사장, 야자수, 수영장 같은 여름 풍경 사진에 이 필터를 쓰면 마치 휴가 있는 것 같은 기분이 들어요."
        ),
        FilterDescriptionModel(
            type: .content,
            headerTitle: nil,
            contentImageURLString: "https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0",
            contentTitle: "노을바다",
            contentDescription: "안녕하세요! 여름을 맞아 에메랄드빛 바다가 생각나는 청량한 필터를 준비했어요. 모래사장, 야자수, 수영장 같은 여름 풍경 사진에 이 필터를 쓰면 마치 휴가 있는 것 같은 기분이 들어요."
        ),
        FilterDescriptionModel(
            type: .content,
            headerTitle: nil,
            contentImageURLString: "https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0",
            contentTitle: "실내",
            contentDescription: "안녕하세요! 여름을 맞아 에메랄드빛 바다가 생각나는 청량한 필터를 준비했어요. 모래사장, 야자수, 수영장 같은 여름 풍경 사진에 이 필터를 쓰면 마치 휴가 있는 것 같은 기분이 들어요."
        )
    ]
    
    func transform(from input: Input) -> Output {
        //TODO: usecase 추가 필요
        let output = Output()
        
        output.descriptionsSubject.send(descriptions)
        
        return output
    }
}
