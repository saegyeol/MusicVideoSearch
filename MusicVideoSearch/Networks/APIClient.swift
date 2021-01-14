//
//  APIClient.swift
//  MusicVideoSearch
//
//  Created by 윤새결 on 2021/01/14.
//

import Foundation
import Alamofire

class APIClient: Session {

  static var shared: APIClient = APIClient()
  
}

protocol APIClientProtocol {
  func request(_ convertible: URLRequestConvertible, interceptor: RequestInterceptor?) -> DataRequest
}

extension Session: APIClientProtocol {
  
}
