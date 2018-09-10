//
//  MoyaProviderType+Rx.swift
//  RxMoyaCache
//
//  Created by Pircate on 2018/4/18.
//  Copyright © 2018年 Pircate. All rights reserved.
//

import RxSwift
import Moya

extension Reactive where Base: MoyaProviderType {
    
    public func cache(_ target: Base.Target) -> TargetProvider<Base> {
        return TargetProvider(target, provider: base)
    }
}
