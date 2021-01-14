//
//  ViewController.swift
//  MusicVideoSearch
//
//  Created by 윤새결 on 2021/01/13.
//

import UIKit
import ReactorKit
import RxCocoa
import RxDataSources

class ViewController: UIViewController, StoryboardView {
  
  let searchController = UISearchController(searchResultsController: nil)
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var firstCountryTextField: UITextField!
  @IBOutlet weak var secondCountryTextField: UITextField!
  
  let trackCellID = "TrackCollectionViewCell"
  let artistNameHeaderViewID = "ArtistNameHeaderView"

  var disposeBag: DisposeBag = DisposeBag()

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    self.setupSearchController()
    self.setupCollectionView(self.collectionView)
  }
  
  func setupCollectionView(_ collectionView: UICollectionView) {
    collectionView.register(UINib(nibName: trackCellID, bundle: nil), forCellWithReuseIdentifier: trackCellID)
    collectionView.register(UINib(nibName: artistNameHeaderViewID, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: artistNameHeaderViewID)
    let layout = UICollectionViewFlowLayout()
    layout.sectionInset = .init(top: 10, left: 0, bottom: 0, right: 0)
    let width = collectionView.frame.width / 3
    layout.itemSize = CGSize(width: width, height: width * 1.5)
    layout.minimumLineSpacing = 0
    layout.minimumInteritemSpacing = 0
    layout.headerReferenceSize.height = 60
    
    collectionView.setCollectionViewLayout(layout, animated: false)
  }
  
  func bind(reactor: ViewControllerReactor) {
    
    let artistInput = self.searchController.searchBar.rx.text.orEmpty.distinctUntilChanged()
    let firstCountryInput = self.firstCountryTextField.rx.text.orEmpty.distinctUntilChanged()
    let secondCountryInput = self.secondCountryTextField.rx.text.orEmpty.distinctUntilChanged()
    
    Observable.combineLatest(artistInput, firstCountryInput, secondCountryInput)
      .debounce(.seconds(1), scheduler: MainScheduler.instance)
      .map { (artist, firstCountry, secondCountry) -> Reactor.Action in
        let inputCountries = [firstCountry, secondCountry].filter {
          $0 != ""
        }
        return Reactor.Action.searchQueriesInput(artist, inputCountries)
    }
    .bind(to: reactor.action)
    .disposed(by: self.disposeBag)
    
    self.collectionView.rx.itemSelected.map {
      return Reactor.Action.tapTrack($0)
    }
    .bind(to: reactor.action)
    .disposed(by: self.disposeBag)
    
    func dataSource() -> RxCollectionViewSectionedReloadDataSource<SectionModel> {
      return RxCollectionViewSectionedReloadDataSource { [weak self] (dataSoruce, collectionView, indexPath, item) -> UICollectionViewCell in
        guard let self = self else { return UICollectionViewCell() }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.trackCellID, for: indexPath) as! TrackCollectionViewCell
        cell.configureCell(with: item)
        
        return cell
      } configureSupplementaryView: { [weak self] (dataSoruce, collectionView, kind, indexPath) -> UICollectionReusableView in
        guard let self = self else { return UICollectionReusableView() }
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: self.artistNameHeaderViewID, for: indexPath) as! ArtistNameHeaderView
        let artistNames = dataSoruce.sectionModels[indexPath.section].artists
        headerView.configureView(with: artistNames)
        
        headerView.rx.artistSelect.map {
          Reactor.Action.tapArtistList($0)
        }
        .bind(to: reactor.action)
        .disposed(by: self.disposeBag)

        return headerView
      }
    }
    
    reactor.state.map {
      $0.sectionModels
    }
    .bind(to: self.collectionView.rx.items(dataSource: dataSource()))
    .disposed(by: self.disposeBag)
    
    reactor.state.compactMap {
      $0.errorMessage
    }
    .bind { [weak self] message in
      self?.presentAlert(with: message)
    }.disposed(by: self.disposeBag)
    
    reactor.state.compactMap {
      $0.selectedArtist
    }
    .distinctUntilChanged()
    .bind { [weak self] artist in
      self?.searchController.searchBar.text = artist
      self?.searchController.isActive = true
    }
    .disposed(by: self.disposeBag)
    
    reactor.state.compactMap {
      $0.selectedTrack
    }
    .bind { [weak self] in
      self?.pushToDetail(with: $0)
    }
    .disposed(by: self.disposeBag)
    
  }
  
  private func pushToDetail(with track: Track) {
    let viewController = UIStoryboard(name: "Detail", bundle: nil).instantiateInitialViewController() as! DetailViewController
    viewController.track = track
    self.navigationController?.pushViewController(viewController, animated: true)
  }
  
  private func presentAlert(with message: String) {
    let alert = UIAlertController(title: "Notice",
                                  message: message,
                                  preferredStyle: .alert)
    let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
    alert.addAction(alertAction)
    self.present(alert, animated: true, completion: nil)
  }

  private func setupSearchController() {
    self.searchController.hidesNavigationBarDuringPresentation = true
    self.searchController.obscuresBackgroundDuringPresentation = false
    self.navigationItem.hidesSearchBarWhenScrolling = false
    self.navigationItem.searchController = self.searchController
  }
}
