//
//  KeychainService.swift
//  Auth
//
//  Created by 이숭인 on 7/12/24.
//

import Foundation

public enum KeychainError: Error {
    case noPassword
    case unexpectedPasswordData
    case unexpectedItemData
    case unhandledError
}

//TODO: 이름 추천좀 받자.
public protocol KeychainService {
    associatedtype KeychainData: Codable
    
    var service: String { get } // App Bundle ID
    var account: String { get } // User ID
    
    func retrieve() throws -> KeychainData
    func save(with data: KeychainData) throws
    func delete() throws
}

extension KeychainService {
    public func retrieve() throws -> KeychainData {
        var query = [String: AnyObject]()
        
        //1. service, account 정보 설정
        query[kSecClass as String] = kSecClassGenericPassword
        query[kSecAttrService as String] = service as AnyObject
        query[kSecAttrAccount as String] = account as AnyObject
        
        // 2. 탐색 결과 제한을 하나로 설정
        query[kSecMatchLimit as String] = kSecMatchLimitOne
        
        // 3. 항목의 속성 정보와 데이터 값을 반환하도록 설정
        query[kSecReturnAttributes as String] = kCFBooleanTrue
        query[kSecReturnData as String] = kCFBooleanTrue
        
        // 4. Keychain 쿼리를 실행하여 결과를 queryResult에 저장
        var queryResult: AnyObject?
        let status = withUnsafeMutablePointer(to: &queryResult) {
            SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
        }
        
        // 5. 항목이 존재하지 않는 경우 오류 처리
        guard status != errSecItemNotFound else { throw KeychainError.noPassword }
        
        // 6. 쿼리 실행 중 오류가 발생한 경우 오류 처리
        guard status == noErr else { throw KeychainError.unhandledError }
        
        guard let existingItem = queryResult as? [String: AnyObject],
              let keychainData = existingItem[kSecValueData as String] as? KeychainData else {
            throw KeychainError.unexpectedPasswordData
        }
        
        return keychainData
    }
    
    public func save(with data: KeychainData) throws {
        var query = [String: AnyObject]()
        var status: OSStatus
        
        //1. service, account 정보 설정
        query[kSecClass as String] = kSecClassGenericPassword
        query[kSecAttrService as String] = service as AnyObject
        query[kSecAttrAccount as String] = account as AnyObject
        
        // 2. Data Encoding Check
        let encodedData = try encode(with: data)
        
        // 3. 존재 여부 체크
        let isExistData = try? retrieve()
        
        if isExistData != nil {
            let attributesToUpdate = [kSecValueData as String: encodedData as AnyObject]
            status = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
        } else {
            query[kSecValueData as String] = encodedData as AnyObject
            status = SecItemAdd(query as CFDictionary, nil)
        }
        
        guard status == noErr else { throw KeychainError.unhandledError }
    }
    
    public func delete() throws {
        var query = [String: AnyObject]()
        
        //1. service, account 정보 설정
        query[kSecClass as String] = kSecClassGenericPassword
        query[kSecAttrService as String] = service as AnyObject
        query[kSecAttrAccount as String] = account as AnyObject
        
        let status = SecItemDelete(query as CFDictionary)
        
        guard status == noErr || status == errSecItemNotFound else {
            throw KeychainError.unhandledError
        }
    }
    
    private func encode(with data: KeychainData) throws -> Data {
        do {
            let encodedData = try JSONEncoder().encode(data)
            print("EncodedData -> Data: \(String(describing: String(data: encodedData, encoding: .utf8)))")
            return encodedData
        } catch {
            throw error
        }
    }
}
