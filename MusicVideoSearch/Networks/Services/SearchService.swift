//
//  SearchService.swift
//  MusicVideoSearch
//
//  Created by 윤새결 on 2021/01/14.
//

import Foundation
import RxSwift

protocol SearchServiceProtocol {
  func search(with params: [String:Any]) -> Observable<([Track], Error?)>
}

struct SearchService: SearchServiceProtocol {
  
  let apiClient: APIClientProtocol
  
  init(client: APIClientProtocol) {
    self.apiClient = client
  }
  
  func search(with params: [String : Any]) -> Observable<([Track], Error?)> {
    return Observable.create { (observer) -> Disposable in
      let request = self.apiClient.request(SearchRouter.search(params), interceptor: nil).responseDecodable(of: SearchResult.self) { response in
        switch response.result {
        case .success(let value):
          observer.onNext((value.results, nil))
        case .failure(let error):
          observer.onNext(([], error))
        }
        observer.onCompleted()
      }
      return Disposables.create {
        request.cancel()
      }
    }
  }
}
