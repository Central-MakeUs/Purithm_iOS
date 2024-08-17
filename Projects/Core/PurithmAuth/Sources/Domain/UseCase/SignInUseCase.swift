//
//  SignInUseCase.swift
//  CorePurithmAuth
//
//  Created by 이숭인 on 7/18/24.
//

import Combine
import CombineExt
import RxSwift
import RxKakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser
import RxKakaoSDKUser
import CoreNetwork

import Moya
import CombineMoya
import Foundation

public final class SignInUseCase {
    private let disposeBag = DisposeBag()
    private var cancellables = Set<AnyCancellable>()
    
    private let repository: AuthRepository
    private let authService: PurithmAuthServiceManageable
    
    public init(repository: AuthRepository, authService: PurithmAuthServiceManageable) {
        self.repository = repository
        self.authService = authService
    }
}

//MARK: - Login validate check
extension SignInUseCase {
    public func testLoggedIn() -> AnyPublisher<Void, Error> {
        return Fail(outputType: Void.self, failure: NetworkError.invalidToken)
            .eraseToAnyPublisher()
    }
    
    public func isAlreadyLoggedIn() -> AnyPublisher<Void, Error> {
        do {
            let purithmToken = try repository.retriveAuthToken()
            
            return Future { [weak self] promise in
                guard let self else { return }
                let publisher = authService.requestTokenValidate(with: purithmToken.accessToken)
                    .share()
                    .materialize()
                    
                publisher.values()
                    .sink { response in
                        let errorType = NetworkError(rawValue: response.code) ?? .invalidErrorType
                        
                        switch errorType {
                        case .success, .successUserSignIn:
                            print("::: retrived purithm token > \(purithmToken)")
                            return promise(.success(Void()))
                        case .termsOfServiceRequired:
                            // 에러 방출 후, 이용약관으로 이동
                            return promise(.failure(PurithmAuthError.termsOfServiceRequired))
                        case .invalidToken, .resourceNotFound:
                            // 에러 방출 후, 로그인 화면으로 이동
                            return promise(.failure(PurithmAuthError.invalidToken))
                        case .invalidErrorType:
                            // 잘못된 서버 응답 코드
                            return promise(.failure(PurithmAuthError.invalidErrorType))
                        default: break
                        }
                    }
                    .store(in: &cancellables)
                
                publisher.failures()
                    .sink { error in
                        return promise(.failure(error))
                    }
                    .store(in: &cancellables)
            }
            .eraseToAnyPublisher()
        } catch {
            print("::: failed retrive token")
            return Fail(outputType: Void.self, failure: PurithmAuthError.invalidErrorType)
                .eraseToAnyPublisher()
        }
    }
}

// MARK: - Kakao Login
extension SignInUseCase {
    public func loginWithKakao() -> AnyPublisher<Void, Error> {
        return Future { [weak self] promise in
            guard let self else { return }
            
            let isKakaoTalkLoginAvailable = UserApi.isKakaoTalkLoginAvailable()
            
            self.kakaoLogin(
                using: isKakaoTalkLoginAvailable ? UserApi.shared.rx.loginWithKakaoTalk() : UserApi.shared.rx.loginWithKakaoAccount(),
                errorType: isKakaoTalkLoginAvailable ? .KakaoTalkLoginFailed : .KakaoAccountLoginFailed
            )
            .flatMap { kakaoAuthentication -> Observable<String> in
                print("kakao accesstoken > \(kakaoAuthentication.accessToken)")
                return self.loginToPurithmServiceForKakao(with: kakaoAuthentication)
            }
            .subscribe(onNext: { purithmToken in
                do {
                    try self.repository.saveAuthToken(
                        accessToken: purithmToken
                    )
                    promise(.success(Void()))
                } catch {
                    promise(.failure(error))
                }
            }, onError: { error in
                promise(.failure(error))
            })
            .disposed(by: self.disposeBag)
        }
        .eraseToAnyPublisher()
    }
    
    private func kakaoLogin(using loginObservable: Observable<OAuthToken>, errorType: AuthError) -> Observable<KakaoSignInRequestDTO> {
        let loginObservable = Observable<OAuthToken>.create { observer in
            let loginObserver = loginObservable.asObservable()
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
            
            return Disposables.create {
                loginObserver.dispose()
            }
        }
        
        let userObsevable = Observable<User>.create { observer in
            let userObserver = UserApi.shared.rx.me().asObservable()
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
            
            return Disposables.create {
                userObserver.dispose()
            }
        }
        
        return loginObservable
            .flatMap { oauthToken in
                userObsevable.map { user in
                    (oauthToken, user)
                }
            }
            .map { (oauthToken, user) in
                let response = KakaoSignInRequestDTO(
                    accessToken: oauthToken.accessToken
                )
                print("::: kakao login response")
                return response
            }
            .asObservable()
    }
    
    private func loginToPurithmServiceForKakao(with parameter: KakaoSignInRequestDTO) -> Observable<String> {
        return Future<String, Error> { [weak self] promise in
            guard let self else { return }
            let publisher = authService.requestKakaoSignIn(with: parameter.accessToken)
                .share()
                .materialize()
            
            publisher.values()
                .sink { response in
                    let tokenResponse = response.data?.accessToken ?? ""
                    
                    return promise(.success(tokenResponse))
                }
                .store(in: &cancellables)
            
            publisher.failures()
                .sink { error in
                    return promise(.failure(error))
                }
                .store(in: &cancellables)
        }
        .eraseToAnyPublisher()
        .asObservable()
    }
}

// MARK: - Apple Login
extension SignInUseCase {
    public func loginWithApple(with idToken: String, name: String) -> AnyPublisher<Void, Error> {
        let appleAuth = AppleSignInRequestDTO(userName: name)
        
        return Future { [weak self] promise in
            guard let self else {
                promise(.failure(AuthError.referenceInvalidError))
                return
            }
            let publisher = loginToPurithmServiceForApple(
                with: appleAuth,
                idToken: idToken
            )
                .share()
                .materialize()
            
            publisher.values()
                .sink { response in
                    do {
                        try self.repository.saveAuthToken(
                            accessToken: response
                        )
                        promise(.success(Void()))
                    } catch {
                        promise(.failure(error))
                    }
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
    
    private func loginToPurithmServiceForApple(with parameter: AppleSignInRequestDTO, idToken: String) -> AnyPublisher<String, Error> {
        return Future { [weak self] promise in
            guard let self else { return }
            let appleRequestModel = AppleSignInRequestDTO(userName: parameter.userName)
            let publisher = authService.requestAppleSignIn(
                with: parameter.toDictionary(),
                token: idToken
            )
                .share()
                .materialize()
            
            publisher.values()
                .sink { response in
                    let tokenResponse = response.data?.accessToken ?? ""
                    return promise(.success(tokenResponse))
                }
                .store(in: &cancellables)
            
            publisher.failures()
                .sink { error in
                    return promise(.failure(error))
                }
                .store(in: &cancellables)
        }
        .eraseToAnyPublisher()
    }
}

//MARK: - Conform Terms
extension SignInUseCase {
    public func conformTerms() -> AnyPublisher<Void, Error> {
        do {
            let purithmToken = try repository.retriveAuthToken()
            
            return Future { [weak self] promise in
                guard let self else { return }
                let publisher = authService.requestTermsConform(with: purithmToken.accessToken)
                    .share()
                    .materialize()
                
                publisher.values()
                    .sink { response in
                        let errorType = NetworkError(rawValue: response.code) ?? .invalidErrorType
                        
                        switch errorType {
                        case .success, .successUserSignIn:
                            return promise(.success(Void()))
                        case .invalidToken, .resourceNotFound:
                            return promise(.failure(PurithmAuthError.invalidToken))
                        case .invalidErrorType:
                            return promise(.failure(PurithmAuthError.invalidErrorType))
                        default:
                            return promise(.failure(errorType))
                        }
                    }
                    .store(in: &cancellables)
                
                publisher.failures()
                    .sink { error in
                        return promise(.failure(error))
                    }
                    .store(in: &cancellables)
            }
            .eraseToAnyPublisher()
        } catch {
            return Fail(outputType: Void.self, failure: PurithmAuthError.invalidErrorType)
                .eraseToAnyPublisher()
        }
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
