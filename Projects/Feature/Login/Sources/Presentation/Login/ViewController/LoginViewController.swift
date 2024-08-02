//
//  LoginViewController.swift
//  Login
//
//  Created by 이숭인 on 7/16/24.
//

import UIKit
import Combine

import SnapKit
import Then
import CombineCocoa

import CorePurithmAuth
import CoreCommonKit
import CoreUIKit

import AuthenticationServices

public final class LoginViewController: ViewController<LoginView> {
    let viewModel: LoginViewModel
    
    var cancellables = Set<AnyCancellable>()
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        bindAction()
        bindViewModel()
    }
    
    private func bindViewModel() {
        let input = LoginViewModel.Input(
            kakaoLoginButtonTapEvent: contentView.kakaoLoginButton.tapPublisher
        )
        
        viewModel.transform(
            from: input
        )
    }
    
    private func bindAction() {
        contentView.appleLoginButton.tapPublisher
            .sink { [weak self] _ in
                guard let self else { return }
                
                let appleIDProvider = ASAuthorizationAppleIDProvider()
                let request = appleIDProvider.createRequest()
                request.requestedScopes = [.fullName, .email]
                
                let authorizationController = ASAuthorizationController(authorizationRequests: [request])
                authorizationController.delegate = self
                authorizationController.presentationContextProvider = self
                authorizationController.performRequests()
            }
            .store(in: &cancellables)
    }

}


extension LoginViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        self.view.window!
    }
    
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let idTokenData = appleIDCredential.identityToken
            let idTokenString = String(data: idTokenData!, encoding: .utf8)
            
            // 사용자의 이름 불러오기
            let fullName = appleIDCredential.fullName
            
            // 이름을 String으로 변환
            let givenName = fullName?.givenName ?? ""
            let familyName = fullName?.familyName ?? ""
            let middleName = fullName?.middleName ?? ""
            
            let userName = [givenName, middleName, familyName].joined(separator: " ").trimmingCharacters(in: .whitespaces)
            
            viewModel.loginWithApple(
                with: idTokenString ?? "",
                name: userName
            )
            print("::: idToken > \(idTokenString)")
            print("::: userName > \(userName)")
        }
    }
}
