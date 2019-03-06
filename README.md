# RxMoyaCache

[![CI Status](https://img.shields.io/travis/Pircate/RxMoyaCache.svg?style=flat)](https://travis-ci.org/Pircate/RxMoyaCache)
[![Version](https://img.shields.io/cocoapods/v/RxMoyaCache.svg?style=flat)](https://cocoapods.org/pods/RxMoyaCache)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![License](https://img.shields.io/cocoapods/l/RxMoyaCache.svg?style=flat)](https://cocoapods.org/pods/RxMoyaCache)
[![Platform](https://img.shields.io/cocoapods/p/RxMoyaCache.svg?style=flat)](https://cocoapods.org/pods/RxMoyaCache)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

RxMoyaCache is available through [CocoaPods](https://cocoapods.org) or [Carthage](https://github.com/Carthage/Carthage). To install
it, simply add the following line to your Podfile or Cartfile:

### CocoaPods
```ruby
pod 'RxMoyaCache'
```

### Carthage
```ruby
github "Pircate/RxMoyaCache"
```

## Usage

### Import
```swift
import RxMoyaCache
```

### Snippet

给 `Storable` 添加默认实现，具体实现请看 Demo
```swift
extension Storable where Self: TargetType {
    
    public var allowsStorage: (Response) -> Bool {
        return MoyaCache.shared.storagePolicyClosure
    }
    
    public func cachedResponse(for key: CachingKey) throws -> Response {
        return try Storage<Moya.Response>().object(forKey: key.stringValue)
    }
    
    public func storeCachedResponse(_ cachedResponse: Response, for key: CachingKey) throws {
        try Storage<Moya.Response>().setObject(cachedResponse, forKey: key.stringValue)
    }
    
    public func removeCachedResponse(for key: CachingKey) throws {
        try Storage<Moya.Response>().removeObject(forKey: key.stringValue)
    }
    
    public func removeAllCachedResponses() throws {
        try Storage<Moya.Response>().removeAll()
    }
}
```

`target` 遵循 `Cacheable` 协议
```swift
enum StoryAPI: TargetType, Cacheable {
    case latest
}
```

读取缓存
```swift
let provider = MoyaProvider<StoryAPI>()
provider.rx.cache
    .request(.latest)
    .map(StoryListModel.self)
    .subscribe(onNext: { object in
        debugPrint("onNext:", object.topStories[0].title)
    }).disposed(by: disposeBag)

// or

provider.rx.onCache(.latest, type: StoryListModel.self) { object in
        debugPrint("onCache", object.topStories[0].title)
    }.request()
    .subscribe(onSuccess: { object in
        debugPrint("onSuccess", object.topStories[0].title)
    }).disposed(by: disposeBag)
```

## Author

Pircate, gao497868860@163.com

## License

RxMoyaCache is available under the MIT license. See the LICENSE file for more info.
