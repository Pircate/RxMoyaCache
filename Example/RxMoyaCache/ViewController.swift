//
//  ViewController.swift
//  RxMoyaCache
//
//  Created by Pircate on 09/10/2018.
//  Copyright (c) 2018 Pircate. All rights reserved.
//

import UIKit
import Moya
import RxSwift
import RxMoyaCache

enum StoryAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://news-at.zhihu.com/api")!
    }
    
    var path: String {
        return "4/news/latest"
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        return "".data(using: .utf8)!
    }
    
    var task: Task {
        return .requestPlain
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    case latest
}

struct StoryListModel: Codable {
    let topStories: [StoryItemModel]
    
    enum CodingKeys: String, CodingKey {
        case topStories = "top_stories"
    }
}

struct StoryItemModel: Codable {
    let id: String
    let title: String
    let image: String
}

class ViewController: UIViewController {
    
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let provider = MoyaProvider<StoryAPI>()
        provider.rx.cache(.latest)
            .request()
            .map(StoryListModel.self)
            .subscribe(onNext: { object in
                debugPrint(object.topStories[0].title)
            }, onError: { error in
                
            }).disposed(by: disposeBag)
    }
}

