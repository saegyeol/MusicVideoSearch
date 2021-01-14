//
//  ArtistNameCollectionViewCell.swift
//  MusicVideoSearch
//
//  Created by 윤새결 on 2021/01/13.
//

import UIKit

class ArtistNameCollectionViewCell: UICollectionViewCell {

  @IBOutlet weak var artistNameLabel: UILabel!

  func configureCell(with name: String) {
    self.artistNameLabel.text = name
  }
}
