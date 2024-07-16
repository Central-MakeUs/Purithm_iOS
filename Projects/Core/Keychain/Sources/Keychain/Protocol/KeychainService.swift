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
    case itemNotFound
    case decodeError(expected: Any.Type, actual: Any.Type)
}

//TODO: 이름 추천좀 받자.
public protocol KeychainService {
    associatedtype KeychainData: Codable
    
    var service: String { get } // App Bundle ID
    var account: String { get } // User ID
    
    func retrieve() throws -> KeychainData?
    func save(with data: KeychainData) throws
    func delete() throws
}

extension KeychainService {
    public func retrieve() throws -> KeychainData? {
        // 1. service, account 정보 설정
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service as AnyObject,
            kSecAttrAccount as String: account as AnyObject,
            kSecReturnData as String: kCFBooleanTrue as AnyObject,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        // Retrieve item from keychain
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        // 2. 상태 처리
        switch status {
        case errSecSuccess:
            guard let data = dataTypeRef as? Data,
                  let decodedData = try? JSONDecoder().decode(KeychainData.self, from: data) else {
                throw KeychainError.decodeError(expected: KeychainData.self, actual: Data.self)
            }
            
            return decodedData
        case errSecItemNotFound:
            throw KeychainError.itemNotFound
        default:
            throw KeychainError.unhandledError
        }
    }
    
    public func save(with data: KeychainData) throws {
        // 1. Data Encoding Check
        let encodedData = try encode(with: data)
        
        // 2. service, account 정보 설정
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service as AnyObject,
            kSecAttrAccount as String: account as AnyObject,
            kSecValueData as String: encodedData as AnyObject
        ]
        var status: OSStatus
        
        // 3. 존재 여부 체크
        let isExistData = try? retrieve()
        
        if isExistData != nil {
            let attributesToUpdate = [kSecValueData as String: encodedData as AnyObject]
            status = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
        } else {
            status = SecItemAdd(query as CFDictionary, nil)
        }
        
        guard status == errSecSuccess else { throw KeychainError.unhandledError }
        print("::: 저장 성공 > \(data)")
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
