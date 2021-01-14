//
//  Routable.swift
//  MusicVideoSearch
//
//  Created by 윤새결 on 2021/01/14.
//

import Foundation
import Alamofire

protocol Routable: URLRequestConvertible {
  var baseUrl: String { get }
  var method: HTTPMethod { get }
  var path: String { get }
  func asURLRequest() throws -> URLRequest
}


