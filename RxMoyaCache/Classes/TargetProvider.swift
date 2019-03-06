//
//  TargetProvider.swift
//  RxMoyaCache
//
//  Created by Pircate on 2018/6/14.
//  Copyright © 2018年 Pircate. All rights reserved.
//

import Moya
import RxSwift

public struct TargetProvider<Provider: MoyaProviderType> where Provider.Target: Cacheable {
    
    private let target: Provider.Target
    private let provider: Provider
    
    init(_ target: Provider.Target, provider: Provider) {
        self.target = target
        self.provider = provider
    }
    
    public func request(callbackQueue: DispatchQueue? = nil) -> Observable<Response> {
        let source = Single.create { single -> Disposable in
            let cancellableToken = self.provider.request(self.target,
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
