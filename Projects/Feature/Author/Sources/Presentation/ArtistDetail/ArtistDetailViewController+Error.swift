//
//  ArtistDetailViewController+Error.swift
//  Author
//
//  Created by 이숭인 on 8/9/24.
//

import Foundation
import Combine
import CoreUIKit
import CoreCommonKit

extension ArtistDetailViewController: PurithmErrorHandlerable {
    public var errorPublisher: AnyPublisher<Error, Never> {
        viewModel.errorPublisher
    }
    
    public func bindErrorHandler() {
        errorPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                self?.presentErrorPopup(with: error)
            }
            .store(in: &cancellables)
    }
    
    public func presentErrorPopup(with error: Error) {
        inputAccessoryView?.resignFirstResponder()
        view.endEditing(true)
        var title: String
        let conformTitle: String = "확인"
        
        //TODO: 추후 UI Layer에러 정의 해야할지도?
        title = "알 수 없는 에러입니다.\n\(error)"
        
        let alert = PurithmAlert(with:
                .withOneButton(
                    title: title,
                    conformTitle: conformTitle
                )
        )
        alert.conformTapEventPublisher
            .receive(on: DispatchQueue.main)
            .sink { _ in
                alert.hide()
            }
            .store(in: &cancellables)
        
        
        alert.show(animated: false)
    }
}
