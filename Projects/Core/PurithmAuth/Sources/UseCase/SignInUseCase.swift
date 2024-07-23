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

public final class SignInUseCase {
    private let disposeBag = DisposeBag()

    private let repository: AuthRepository
    private var cancellables = Set<AnyCancellable>()
    
    public init(repository: AuthRepository) {
        self.repository = repository
    }
}

//MARK: - Login validate check
extension SignInUseCase {
    public func isAlreadyLoggedIn() -> Bool {
        return false
//        do {
//            let purithmToken = try repository.retriveAuthToken()
//            //TODO: 토큰 검증 및 refresh 작업 후 재 저장
//            print("::: retrive token > \(purithmToken)")
//            return true
//        } catch {
//            print("::: failed retrive token")
//            return false
//        }
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
            .flatMap { kakaoAuthentication -> Observable<PurithmTokenResponse> in
                return self.loginToPurithmServiceForKakao(with: kakaoAuthentication)
            }
            .subscribe(onNext: { purithmToken in
                do {
                    try self.repository.saveAuthToken(
                        accessToken: purithmToken.accessToken,
                        refreshToken: purithmToken.refreshToken
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
    
    private func kakaoLogin(using loginObservable: Observable<OAuthToken>, errorType: AuthError) -> Observable<KakaoLoginRequest> {
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
                
                let response = KakaoLoginRequest(
                    userName: user.kakaoAccount?.profile?.nickname ?? "",
                    accessToken: oauthToken.accessToken,
                    refreshToken: oauthToken.refreshToken
                )
                print("::: kakao login response")
                return response
            }
            .asObservable()
    }
    
    // TODO: 실제 카카오 토큰 정보를 Purithm 서버로 넘기기 + 서버 response interface 맞춰서 response type 설정하기
    private func loginToPurithmServiceForKakao(with parameter: KakaoLoginRequest) -> Observable<PurithmTokenResponse> {
        //TODO: Return 타입 정의 필요 + 해당 위치에서 받아온 값 Keychain 에 저장
        let mockJson = """
                        {
                            "code": 200,
                            "timestamp": "timestamp",
                            "data": {
                                "name": "name",
                                "accessToken": "accessToken",
                                "refreshToken": "refreshToken"
                            },
                            "message": "message"
                        }
                        """
        
        return KakaoLoginRequestBuilder().mockRequest(from: mockJson).asObservable()
    }
}

// MARK: - Apple Login
extension SignInUseCase {
    public func loginWithApple(with idToken: String, name: String) -> AnyPublisher<Void, Error> {
        let appleAuth = AppleLoginRequest(userName: name, idToken: idToken)
        
        return Future { [weak self] promise in
            guard let self else {
                promise(.failure(AuthError.referenceInvalidError))
                return
            }
            let publisher = loginToPurithmServiceForApple(with: appleAuth).share().materialize()
                
            publisher.values()
                .sink { response in
                    do {
                        try self.repository.saveAuthToken(
                            accessToken: response.accessToken,
                            refreshToken: response.refreshToken
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
    
    private func loginToPurithmServiceForApple(with parameter: AppleLoginRequest) -> AnyPublisher<PurithmTokenResponse, Error> {
        let mockJson = """
                        {
                            "code": 200,
                            "timestamp": "timestamp",
                            "data": {
                                "name": "name",
                                "accessToken": "accessToken",
                                "refreshToken": "refreshToken"
                            },
                            "message": "message"
                        }
                        """
        
        return AppleLoginRequestBuilder().mockRequest(from: mockJson)
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
