//
//  Track.swift
//  MusicVideoSearch
//
//  Created by 윤새결 on 2021/01/13.
//

import Foundation

struct Track: Codable {
  let trackId: Int
  let artistName: String
  let trackName: String
  let artworkUrl100: String
}

extension Track: Equatable {
  static func == (lhs: Track, rhs: Track) -> Bool {
    return lhs.trackId == rhs.trackId
  }
}
