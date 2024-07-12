//
//  NetworkError.swift
//  CoreNetwork
//
//  Created by 이숭인 on 7/11/24.
//

import Foundation

//TODO: Purithm 서비스 에러 여기 정리?
public enum NetworkError: Int, Error {
    case noPermission = 400
    case noPermissionSecond = 401
}
