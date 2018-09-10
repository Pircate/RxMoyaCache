//
//  TargetType+Cache.swift
//  RxMoyaCache
//
//  Created by Pircate on 2018/7/7.
//  Copyright © 2018年 Pircate. All rights reserved.
//

import Moya
import Cache
import RxSwift

public extension TargetType {
    
    func cachedObject<C: Codable>(_ type: C.Type) throws -> C {
        return try MoyaCache.shared.cachedObject(type, for: self)
    }
    
    func storeCachedObject<C: Codable>(_ cachedObject: C) throws {
        try MoyaCache.shared.storeCachedObject(cachedObject, for: self)
    }

    func removeCachedObject<C: Codable>(_ type: C.Type) throws {
        try MoyaCache.shared.removeCachedObject(type, for: self)
    }
}

public extension TargetType {
    
    func cachedResponse() throws -> Moya.Response {
        return try MoyaCache.shared.cachedResponse(for: self)
    }
    
    func storeCachedResponse(_ cachedResponse: Moya.Response) throws {
        try MoyaCache.shared.storeCachedResponse(cachedResponse, for: self)
    }
    
    func removeCachedResponse() throws {
        try MoyaCache.shared.removeCachedResponse(for: self)
    }
}

extension TargetType {
    
    var cachedKey: String {
        if let urlRequest = try? endpoint.urlRequest(),
            let data = urlRequest.httpBody,
            let parameters = String(data: data, encoding: .utf8) {
            return "\(method.rawValue):\(endpoint.url)?\(parameters)"
        }
        return "\(method.rawValue):\(endpoint.url)"
    }
    
    private var endpoint: Endpoint {
        return Endpoint(url: URL(target: self).absoluteString,
                        sampleResponseClosure: { .networkResponse(200, self.sampleData) },
                        method: method,
                        task: task,
                        httpHeaderFields: headers)
    }
}
