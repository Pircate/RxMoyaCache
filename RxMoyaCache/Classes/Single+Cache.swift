//
//  Single+Cache.swift
//  RxMoyaCache
//
//  Created by Pircate on 2018/4/18.
//  Copyright © 2018年 Pircate. All rights reserved.
//

import RxSwift
import Moya
import Cache

extension PrimitiveSequence where TraitType == SingleTrait, ElementType: Codable {
    
    public func storeCachedObject(for target: TargetType) -> Single<ElementType> {
        return map { object -> ElementType in
            try? target.storeCachedObject(object)
            return object
        }
    }
}

extension PrimitiveSequence where TraitType == SingleTrait, ElementType == Moya.Response {
    
    public func storeCachedResponse(for target: TargetType) -> Single<ElementType> {
        return map { response -> ElementType in
            if MoyaCache.shared.storagePolicyClosure(response) {
                try? target.storeCachedResponse(response)
            }
            return response
        }
    }
}
