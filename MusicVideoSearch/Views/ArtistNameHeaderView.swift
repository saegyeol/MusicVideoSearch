//
//  ArtistNameHeaderView.swift
//  MusicVideoSearch
//
//  Created by 윤새결 on 2021/01/13.
//

import UIKit
import RxSwift
import RxCocoa

class ArtistNameHeaderView: UICollectionReusableView {
  
  let collectionViewCellID = "ArtistNameCollectionViewCell"
  
  @IBOutlet weak var collectionView: UICollectionView!
  
  var artists: [String] = []
  
  override func awakeFromNib() {
    super.awakeFromNib()
    self.setupCollectionView(self.collectionView)
  }
  
  func configureView(with artists: [String]) {
    self.artists = artists
    DispatchQueue.main.async { [weak self] in
      self?.collectionView.reloadData()
    }
  }
    
  private func setupCollectionView(_ collectionView: UICollectionView) {
    let nib = UINib(nibName: self.collectionViewCellID, bundle: nil)
    collectionView.register(nib, forCellWithReuseIdentifier: self.collectionViewCellID)
    collectionView.dataSource = self
    if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
      layout.estimatedItemSize = CGSize(width: 80, height: 60)
      layout.itemSize = UICollectionViewFlowLayout.automaticSize
      layout.sectionInset = .init(top: 0, left: 0, bottom: 0, right: 0)
    }
  }
}

extension ArtistNameHeaderView: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return artists.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.collectionViewCellID, for: indexPath) as! ArtistNameCollectionViewCell
    let artist = self.artists[indexPath.item]
    cell.configureCell(with: artist)
    
    return cell
  }
}

extension Reactive where Base: ArtistNameHeaderView {
  var artistSelect: ControlEvent<IndexPath> {
    let event = base.collectionView.rx.itemSelected
    return event
  }
}
