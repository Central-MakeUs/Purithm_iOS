//
//  AuthRepository.swift
//  Auth
//
//  Created by 이숭인 on 7/10/24.
//

import Combine
import RxSwift
import RxCocoa

import KakaoSDKCommon
import RxKakaoSDKCommon
import KakaoSDKAuth
import RxKakaoSDKAuth
import KakaoSDKUser
import RxKakaoSDKUser
import AuthenticationServices
import NetworkCore

import Alamofire

protocol AuthenticationManageable {
    func isAlreadyLoggedIn() -> Bool
    func loginWithKakao() -> AnyPublisher<Void, Error>
    func loginWithApple(with idToken: String) -> AnyPublisher<Void, Error>
}

public final class AuthRepository: AuthenticationManageable {
    public typealias TokenInformation = (accessToken: String, refreshToken: String)
    
    let disposeBag = DisposeBag()
    var cancellables = Set<AnyCancellable>()
}

//MARK: - Login Check
extension AuthRepository {
    public func isAlreadyLoggedIn() -> Bool {
        //TODO: purithm service token check in local keychain
        return false
    }
}

//MARK: - Kakao Login
extension AuthRepository {
    public func loginWithKakao() -> AnyPublisher<Void, Error> {
        return Future { [weak self] promise in
            guard let self else { return }
            
            let isKakaoTalkLoginAvailable = UserApi.isKakaoTalkLoginAvailable()
            
            self.kakaoLogin(
                using: isKakaoTalkLoginAvailable ? UserApi.shared.rx.loginWithKakaoTalk() : UserApi.shared.rx.loginWithKakaoAccount(),
                errorType: isKakaoTalkLoginAvailable ? .KakaoTalkLoginFailed : .KakaoAccountLoginFailed
            )
            .flatMap { kakaoAuthentication -> Observable<EmptyResponseType> in
                return self.loginToPurithmServiceForKakao(with: kakaoAuthentication)
            }
            .subscribe(onNext: { purithmServiceTokenInformation in
                // TODO: KeyChain에 Purithm token 정보 저장
                promise(.success(Void()))
            }, onError: { error in
                promise(.failure(error))
            })
            .disposed(by: self.disposeBag)
        }
        .eraseToAnyPublisher()
    }
    
    private func kakaoLogin(using loginObservable: Observable<OAuthToken>, errorType: AuthError) -> Observable<KakaoAuthenticationInformantion> {
        let loginObservable = Observable<OAuthToken>.create { observer in
            loginObservable
                .catch { error in
                    return Observable.error(errorType)
                }
                .subscribe(onNext: { oauthToken in
                    print("::: oauthToken success")
                    observer.onNext(oauthToken)
                    observer.onCompleted()
                }, onError: { error in
                    print("::: oauthToken error > \(error as? AuthError)")
                    observer.onError(error)
                })
        }
        
        let userObsevable = Observable<User>.create { observer in
            UserApi.shared.rx.me().asObservable()
                .catch { error in
                    return Observable.error(errorType)
                }
                .subscribe(onNext: { user in
                    print("::: user success")
                    observer.onNext(user)
                    observer.onCompleted()
                }, onError: { error in
                    print("::: user error > \(error as? AuthError)")
                    observer.onError(error)
                })
        }
        
        return Observable.zip(loginObservable, userObsevable)
            .map { oauthToken, user in
                let response = KakaoAuthenticationInformantion(
                    userName: user.kakaoAccount?.name ?? "",
                    accessToken: oauthToken.accessToken,
                    refreshToken: oauthToken.refreshToken
                )
                print("::: kakao login response")
                return response
            }
            .asObservable()
    }
    
    // TODO: 실제 카카오 토큰 정보를 Purithm 서버로 넘기기 + 서버 response interface 맞춰서 response type 설정하기
    private func loginToPurithmServiceForKakao(with kakaoAuthentication: KakaoAuthenticationInformantion) -> Observable<EmptyResponseType> {
        //TODO: Return 타입 정의 필요 + 해당 위치에서 받아온 값 Keychain 에 저장
        return KakaoLoginRequestBuilder().mockRequest(from: "예상 response json string 입력 해야함~~").asObservable()
    }
}

//MARK: - Apple Login
extension AuthRepository {
    public func loginWithApple(with idToken: String) -> AnyPublisher<Void, Error> {
        let appleAuth = AppleAuthenticationInformantion(userName: "이름입니다.", idToken: "~~~~~~~")
        
        return Future { [weak self] promise in
            guard let self else {
                promise(.failure(AuthError.referenceInvalidError))
                return
            }
            let publisher = loginToPurithmServiceForApple(with: appleAuth).share().materialize()
                
            publisher.values()
                .sink { response in
                    //TODO: Keychain에 저장
                    promise(.success(Void()))
                }
                .store(in: &cancellables)
            
            publisher.failures()
                .sink { error in
                    promise(.failure(error))
                }
                .store(in: &cancellables)
        }
        .eraseToAnyPublisher()
    }
    
    private func loginToPurithmServiceForApple(with appleAuthentication: AppleAuthenticationInformantion) -> AnyPublisher<EmptyResponseType, Error> {
        return AppleLoginRequestBuilder().mockRequest(from: "예상 response json string 입력 해야함~~")
    }
}

//TODO: Core로 옮기자
extension Publisher {
    func asObservable() -> Observable<Output> {
        Observable<Output>.create { observer in
            let cancellable = self.sink { completion in
                switch completion {
                case .finished:
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            } receiveValue: { value in
                observer.onNext(value)
            }
            
            return Disposables.create {
                cancellable.cancel()
            }
        }
    }
}

//to-do list
// 1. 네트워크 모듈 추가하기 [x]
// 2. mocking을 포함한 서비스 통신로직 구현
// 3. auth feature 모듈을 상세 분리하기. auth는 core로, login은 feature로 추가하자

