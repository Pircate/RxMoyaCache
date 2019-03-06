//
//  Provider.swift
//  RxMoyaCache
//
//  Created by Pircate on 2018/6/14.
//  Copyright © 2018年 Pircate. All rights reserved.
//

import Moya
import RxSwift

public struct CacheProvider<Provider: MoyaProviderType> where Provider.Target: Cacheable {
    
    let provider: Provider
    
    public func request(
        _ target: Provider.Target,
        callbackQueue: DispatchQueue? = nil)
        -> Observable<Response>
    {
        let source = Single.create { single -> Disposable in
            let cancellableToken = self.provider.request(
                target,
                callbackQueue: callbackQueue,
                progress: nil)
            { result in
                switch result {
                case let .success(response):
                    single(.success(response))
                case let .failure(error):
                    single(.error(error))
                }
            }
            
            return Disposables.create {
                cancellableToken.cancel()
            }
        }.storeCachedResponse(for: target).asObservable()
        
        if let response = try? target.cachedResponse(),
            target.allowsStorage(response) {
            return source.startWith(response)
        }
        return source
    }
}

public struct OnCacheProvider<Provider: MoyaProviderType, T: Codable> where Provider.Target: Cacheable {
    
    let target: Provider.Target
    
    let provider: Provider
    
    let keyPath: String?
    
    let decoder: JSONDecoder
    
    public func request(callbackQueue: DispatchQueue? = nil) -> Single<T> {
        return Single.create { single -> Disposable in
            let cancellableToken = self.provider.request(
                self.target,
                callbackQueue: callbackQueue,
                progress: nil)
            { result in
                switch result {
                case let .success(response):
                    single(.success(response))
                case let .failure(error):
                    single(.error(error))
                }
            }
            
            return Disposables.create { cancellableToken.cancel() }
            }
            .storeCachedResponse(for: target)
            .map(T.self, atKeyPath: keyPath, using: decoder)
    }
}
