//
//  LoginViewController.swift
//  Purithm
//
//  Created by 이숭인 on 7/11/24.
//

import UIKit
import Auth
import SnapKit
import Then

import Combine
import CombineCocoa

final class LoginViewController: UIViewController {
    var cancellables = Set<AnyCancellable>()
    
    let kakaoLoginButton = UIButton().then {
        $0.setTitle("카카오 로그인", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .systemBlue
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupSubviews()
        setupConstraints()
        bindAction()
    }
    
    private func setupSubviews() {
        view.addSubview(kakaoLoginButton)
    }
    
    private func setupConstraints() {
        kakaoLoginButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(320)
            make.height.equalTo(32)
        }
    }
    
    private func bindAction() {
        kakaoLoginButton.tapPublisher
            .sink { [weak self] _ in
                guard let self else { return }
                
                AuthManager.shared.loginWithKakao()
                    .sink { completion in
                        switch completion {
                        case .finished:
                            print("::: complete")
                        case .failure(let error):
                            print("::: login failed > \(error)")
                        }
                    } receiveValue: { _ in
                        //TODO: 로그인 성공 > 메인화면(or 약관 화면으로 이동)
                        print("::: 메인화면으로 이동")
                    }
                    .store(in: &cancellables)
            }
            .store(in: &cancellables)
    }
}
