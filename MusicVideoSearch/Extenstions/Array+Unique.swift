//
//  Array+Unique.swift
//  MusicVideoSearch
//
//  Created by 윤새결 on 2021/01/13.
//

import Foundation

extension Array where Element : Equatable {
  var unique: [Element] {
    var uniqueValues: [Element] = []
    self.forEach { item in
      if !uniqueValues.contains(item) {
        uniqueValues += [item]
      }
    }
    return uniqueValues
  }
}
