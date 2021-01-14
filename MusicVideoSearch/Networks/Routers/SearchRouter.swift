//
//  SearchRouter.swift
//  MusicVideoSearch
//
//  Created by 윤새결 on 2021/01/14.
//

import Foundation
import Alamofire

enum SearchRouter: Routable {
  case search(Parameters)
  
  var baseUrl: String {
    return "https://itunes.apple.com"
  }
  
  var method: HTTPMethod {
    switch self {
    case .search:
      return .get
    }
  }
  
  var path: String {
    switch self {
    case .search:
      return "/search"
    }
  }
  
  func asURLRequest() throws -> URLRequest {
    let url = try self.baseUrl.asURL()
    var urlRequest = URLRequest(url: url.appendingPathComponent(path))
    urlRequest.httpMethod = method.rawValue
    
    switch self {
    case .search(let parameters):
      urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
    }
    return urlRequest
  }
}
