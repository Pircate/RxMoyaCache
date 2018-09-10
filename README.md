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
```swift
let provider = MoyaProvider<StoryAPI>()
provider.rx.cache(.latest)
    .request()
    .map(StoryListModel.self)
    .subscribe(onNext: { object in

    }, onError: { error in

    }).disposed(by: disposeBag)
```

## Author

Pircate, gao497868860@163.com

## License

RxMoyaCache is available under the MIT license. See the LICENSE file for more info.
