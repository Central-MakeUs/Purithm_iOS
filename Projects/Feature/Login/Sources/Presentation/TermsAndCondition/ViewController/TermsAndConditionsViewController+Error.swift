//
//  TermsAndConditionsViewController+Error.swift
//  Login
//
//  Created by 이숭인 on 8/3/24.
//

import Foundation
import Combine
import CoreCommonKit
import CoreNetwork
import CorePurithmAuth
import CoreUIKit

extension PurithmErrorHandlerable {
    func bindErrorHandler() {
        errorPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                self?.presentErrorPopup(with: error)
            }
            .store(in: &cancellables)
    }
    
    func presentErrorPopup(with error: Error) {
        inputAccessoryView?.resignFirstResponder()
        view.endEditing(true)
        var title: String
        let conformTitle: String = "확인"
        
        switch error {
        case let authError as PurithmAuthError:
            title = authError.localizedDescription
        case let networkError as NetworkError:
            title = networkError.localizedDescription
        default:
            title = "알 수 없는 에러입니다.\n\(error)"
            
        }
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
        
        
        alert.show(animated: true)
    }
}
