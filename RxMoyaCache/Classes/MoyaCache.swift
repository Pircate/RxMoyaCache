//
//  MoyaCache.swift
//  RxMoyaCache
//
//  Created by Pircate on 2018/7/7.
//  Copyright © 2018年 Pircate. All rights reserved.
//

import Cache
import Moya
import RxSwift

public class MoyaCache {
    
    public static let shared = MoyaCache()
    
    public var storagePolicyClosure: (Moya.Response) -> Bool = { _ in true }
    
    private init() {}
}

public extension MoyaCache {
    
    func removeAllCachedData() throws {
        try removeAllCachedObjects()
        try removeAllCachedResponses()
    }
}

public extension MoyaCache {
    
    func cachedObject<C: Codable>(_ type: C.Type, for target: TargetType) throws -> C {
        return try Storage<C>().object(forKey: target.cachedKey)
    }
    
    func storeCachedObject<C: Codable>(_ cachedObject: C, for target: TargetType) throws {
        try Storage<C>().setObject(cachedObject, forKey: target.cachedKey)
    }
    
    func removeCachedObject<C: Codable>(_ type: C.Type, for target: TargetType) throws {
        try Storage<C>().removeObject(forKey: target.cachedKey)
    }
    
    private func removeAllCachedObjects() throws {
        try Storage<String>().removeAll()
    }
}

public extension MoyaCache {
    
    func cachedResponse(for target: TargetType) throws -> Moya.Response {
        return try Storage<Moya.Response>().object(forKey: target.cachedKey)
    }
    
    func storeCachedResponse(_ cachedResponse: Moya.Response, for target: TargetType) throws {
        try Storage<Moya.Response>().setObject(cachedResponse, forKey: target.cachedKey)
    }
    
    func removeCachedResponse(for target: TargetType) throws {
        try Storage<Moya.Response>().removeObject(forKey: target.cachedKey)
    }
    
    private func removeAllCachedResponses() throws {
        try Storage<Moya.Response>().removeAll()
    }
}

fileprivate extension MoyaCache {
    
    struct DiskStorageName {
        
        static let object = "com.pircate.github.cache.object"
        
        static let response = "com.pircate.github.cache.response"
    }
}

fileprivate extension Storage where T: Codable {
    
    convenience init() throws {
        try self.init(diskConfig: DiskConfig(name: MoyaCache.DiskStorageName.object),
                      memoryConfig: MemoryConfig(),
                      transformer: TransformerFactory.forCodable(ofType: T.self))
    }
}

fileprivate extension Storage where T == Moya.Response {
    
    convenience init() throws {
       try self.init(diskConfig: DiskConfig(name: MoyaCache.DiskStorageName.response),
                     memoryConfig: MemoryConfig(),
                     transformer: Transformer<T>(
                        toData: { $0.data },
                        fromData: { T(statusCode: 200, data: $0) }))
    }
}
