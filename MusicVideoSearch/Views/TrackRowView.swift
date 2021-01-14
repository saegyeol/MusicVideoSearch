//
//  TrackRowView.swift
//  MusicVideoSearch
//
//  Created by 윤새결 on 2021/01/13.
//

import UIKit
import Kingfisher

class TrackRowView: BaseXibView {

  @IBOutlet weak var trackImageView: UIImageView!
  @IBOutlet weak var artistNameLabel: UILabel!
  @IBOutlet weak var trackNameLabel: UILabel!
  
  func configureRowView(with track: Track) {
    self.trackImageView.kf.setImage(with: track.artworkUrl100.asEncodedURL())
    self.artistNameLabel.text = track.artistName
    self.trackNameLabel.text = track.trackName
  }
}
