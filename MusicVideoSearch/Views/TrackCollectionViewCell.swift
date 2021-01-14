//
//  TrackCollectionViewCell.swift
//  MusicVideoSearch
//
//  Created by 윤새결 on 2021/01/13.
//

import UIKit

class TrackCollectionViewCell: UICollectionViewCell {

  @IBOutlet weak var rowView: TrackRowView!
  
  func configureCell(with track: Track) {
    self.rowView.configureRowView(with: track)
  }
}
