//
//  MoyaProviderType+Rx.swift
//  RxMoyaCache
//
//  Created by Pircate on 2018/4/18.
//  Copyright © 2018年 Pircate. All rights reserved.
//

import RxSwift
import Moya

extension Reactive where Base: MoyaProviderType, Base.Target: Cacheable {
    
    public var cache: CacheProvider<Base> {
        return CacheProvider(provider: base)
    }
    
    public func onCache<T: Codable>(
        _ target: Base.Target,
        type: T.Type,
        atKeyPath keyPath: String? = nil,
        using decoder: JSONDecoder = .init(),
        _ closure: (T) -> Void)
        -> OnCacheProvider<Base, T>
    {
        if let object = try? target.cachedResponse()
            .map(type, atKeyPath: keyPath, using: decoder) {
            closure(object)
        }
        
        return OnCacheProvider(target: target, provider: base, keyPath: keyPath, decoder: decoder)
    }
}
