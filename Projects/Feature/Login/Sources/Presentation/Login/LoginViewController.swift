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

import AuthenticationServices

public final class LoginViewController: UIViewController {
    let viewModel: LoginViewModel
    
    var cancellables = Set<AnyCancellable>()
    
    private let backgroundImage = UIImageView().then {
        $0.image = .bgLg
        $0.contentMode = .scaleAspectFill
    }
    
    private let logoImage = UIImageView().then {
        $0.image = .logoType3D
        $0.contentMode = .scaleAspectFit
    }
    
    private let logoLabel = UILabel().then {
        $0.text = "감성사진을 위한 필터 커머스, 퓨리즘"
        $0.font = .systemFont(ofSize: 17, weight: .semibold)
        $0.textColor = .blue400
    }
    
    private let appleLoginButton = UIButton().then {
        $0.setBackgroundImage(.appleLoginButton, for: .normal)
        $0.imageView?.contentMode = .scaleAspectFit
    }
    
    private let kakaoLoginButton = UIButton().then {
        $0.setBackgroundImage(.kakaoLoginButton, for: .normal)
        $0.imageView?.contentMode = .scaleAspectFit
    }
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupSubviews()
        setupConstraints()
        bindAction()
        bindViewModel()
    }
    
    private func bindViewModel() {
        let input = LoginViewModel.Input(
            kakaoLoginButtonTapEvent: kakaoLoginButton.tapPublisher
        )
        
        viewModel.transform(
            from: input
        )
    }
    
    private func setupSubviews() {
        view.addSubview(backgroundImage)
        view.addSubview(logoImage)
        view.addSubview(logoLabel)
        view.addSubview(appleLoginButton)
        view.addSubview(kakaoLoginButton)
    }
    
    private func setupConstraints() {
        backgroundImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        logoImage.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(256)
            make.horizontalEdges.equalToSuperview().inset(32)
            make.height.equalTo(112)
        }
        
        logoLabel.snp.makeConstraints { make in
            make.top.equalTo(logoImage.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
        }
        
        appleLoginButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(48)
            make.bottom.equalTo(kakaoLoginButton.snp.top).offset(-16)
        }
        
        kakaoLoginButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(32)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }
    }
    
    private func bindAction() {
        appleLoginButton.tapPublisher
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
            let authorizationCode = appleIDCredential.authorizationCode
            
            let idTokenString = String(data: idTokenData!, encoding: .utf8)
            let authorizationCodeString = String(data: authorizationCode!, encoding: .utf8)
            
            print("::: idToken > \(idTokenString)")
            print("::: idToken > \(authorizationCodeString)")
        }
    }
}
