//
//  DetailViewController.swift
//  MusicVideoSearch
//
//  Created by 윤새결 on 2021/01/14.
//

import UIKit

class DetailViewController: UIViewController {
  
  var track: Track!
  
  @IBOutlet weak var rowView: TrackRowView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    guard let track = self.track else {
      fatalError("Track is nil")
    }
    self.configureRowView(with: track)
  }
  
  private func configureRowView(with track: Track) {
    self.rowView.configureRowView(with: track)
  }
}
