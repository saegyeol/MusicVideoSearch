//
//  String+URLEncoding.swift
//  MusicVideoSearch
//
//  Created by 윤새결 on 2021/01/13.
//

import Foundation

extension String {
  func asEncodedURL() -> URL {
    guard
      let encodedURLString = self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
      let url = URL(string: encodedURLString)
      else {
        return URL(string: "about:blank")!
    }

    return url
  }
}
