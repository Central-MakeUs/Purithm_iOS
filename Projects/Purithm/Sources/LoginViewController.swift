//
//  LoginViewController.swift
//  Purithm
//
//  Created by 이숭인 on 7/11/24.
//

import UIKit
import CorePurithmAuth
import SnapKit
import Then

import Combine
import CombineCocoa

final class LoginViewController: UIViewController {
    var cancellables = Set<AnyCancellable>()
    
    private let backgroundImage = UIImageView().then {
        $0.image = PurithmAsset.Assets.loginBackground2.image
        $0.contentMode = .scaleAspectFill
    }
    
    private let logoImage = UIImageView().then {
        $0.image = PurithmAsset.Assets.loginLogo.image
        $0.contentMode = .scaleAspectFit
    }
    
    private let logoLabel = UILabel().then {
        $0.text = "감성사진을 위한 필터 커머스, 퓨리즘"
        $0.font = .systemFont(ofSize: 17, weight: .semibold)
        $0.textColor = PurithmAsset.Assets.purple500.color
    }
    
    private let appleLoginButton = UIButton().then {
        $0.setImage(PurithmAsset.Assets.appleidButton.image, for: .normal)
        $0.imageView?.contentMode = .scaleAspectFit
        $0.contentHorizontalAlignment = .fill // 버튼의 수평 방향으로 이미지를 채움
        $0.contentVerticalAlignment = .fill // 버튼의 수직 방향으로 이미지를 채움
    }
    
    private let kakaoLoginButton = UIButton().then {
        $0.setImage(PurithmAsset.Assets.kakaoLoginButton.image, for: .normal)
        $0.imageView?.contentMode = .scaleAspectFit
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupSubviews()
        setupConstraints()
        bindAction()
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
            make.height.equalTo(64)
            make.bottom.equalTo(kakaoLoginButton.snp.top).offset(-16)
        }
        
        kakaoLoginButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(32)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(64)
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
                        let vc = TermsAndConditionsViewController()
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    .store(in: &cancellables)
            }
            .store(in: &cancellables)
    }
}
