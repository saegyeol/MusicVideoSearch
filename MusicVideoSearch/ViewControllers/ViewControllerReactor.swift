//
//  ViewControllerReactor.swift
//  MusicVideoSearch
//
//  Created by 윤새결 on 2021/01/13.
//

import Foundation
import ReactorKit
import RxDataSources

class ViewControllerReactor: Reactor {
  var initialState: State = State()
  
  var searchService: SearchServiceProtocol
  
  enum Mutation {
    case loadTrackList([Track], Error?, [String])
    case resetCurrentTracks
    case notInput
    case resetErrorMessage
    case selectTrack(IndexPath)
    case resetSelectedTrack
    case selectArtist(IndexPath)
  }
  
  enum Action {
    case searchQueriesInput(String, [String])
    case tapArtistList(IndexPath)
    case tapTrack(IndexPath)
  }
  
  init(service: SearchServiceProtocol) {
    self.searchService = service
  }
  
  struct State {
    var sectionModels: [SectionModel] = [.searchResult([])]
    var currentCountries: [String]?
    var selectedArtist: String?
    var errorMessage: String?
    var selectedTrack: Track?
    var currentArtists: [String] = []
    var errors: [Error] = []
  }
  
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .searchQueriesInput(let artist, let countries):
      guard !countries.isEmpty else {
        return Observable.just(Mutation.notInput)
      }
      guard artist != "" else {
        return Observable.just(Mutation.notInput)
      }
      let params = countries.map {
        self.params(artist: artist, country: $0)
      }
      let requests = self.request(with: params, countries: countries)
      let errorReset = Observable.just(Mutation.resetErrorMessage)
      let currentTrackReset = Observable.just(Mutation.resetCurrentTracks)
      return Observable.concat([currentTrackReset, requests, errorReset])
    case .tapArtistList(let index):
      guard let countries = self.currentState.currentCountries else {
        return Observable.just(Mutation.notInput)
      }
      let artist = self.currentState.currentArtists[index.item]
      let params = countries.map {
        self.params(artist: artist, country: $0)
      }
      let updateSelectedArtist = Observable.just(Mutation.selectArtist(index))
      let currentTrackReset = Observable.just(Mutation.resetCurrentTracks)
      let errorReset = Observable.just(Mutation.resetErrorMessage)
      let requests = self.request(with: params, countries: countries)
      return Observable.concat([updateSelectedArtist, currentTrackReset, requests, errorReset])
    case .tapTrack(let index):
      let select = Observable.just(Mutation.selectTrack(index))
      let reset = Observable.just(Mutation.resetSelectedTrack)
      return Observable.concat([select, reset])
    }
  }
  


  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state

    switch mutation {
    case .loadTrackList(let tracks, let error, let countries):
      let currentItems = newState.sectionModels[0].items
      if currentItems.isEmpty {
        newState.sectionModels[0] = .searchResult(tracks)
      } else {
        newState.sectionModels[0] = .searchResult(currentItems + tracks)
      }
      if let error = error {
        newState.errors.append(error)
      }
      if newState.errors.count == 2 {
        let message = newState.errors.map {
          $0.localizedDescription
        }.joined(separator: "\n")
        newState.errorMessage = message
      }
      newState.currentCountries = countries
      newState.currentArtists = newState.sectionModels[0].artists
    case .notInput:
      break
    case .resetErrorMessage:
      newState.errorMessage = nil
    case .selectTrack(let indexPath):
      newState.selectedTrack = newState.sectionModels[0].items[indexPath.item]
    case .resetSelectedTrack:
      newState.selectedTrack = nil
    case .resetCurrentTracks:
      newState.sectionModels[0] = .searchResult([])
      newState.errors = []
    case .selectArtist(let indexPath):
      newState.selectedArtist = newState.currentArtists[indexPath.item]
    }
    return newState
  }
  
  private func request(with params: [[String:Any]], countries: [String]) -> Observable<ViewControllerReactor.Mutation> {
    let requests = Observable.concat(params.map {
      self.searchService.search(with: $0)
        .catchError({ error -> Observable<([Track], Error?)> in
          return .just(([], error))
        })
        .map {
          Mutation.loadTrackList($0.0, $0.1, countries)
        }
    })
    return requests
  }
  
  private func params(artist: String, country: String) -> [String:Any] {
    var params = [String:Any]()
    params["entity"] = "musicVideo"
    params["term"] = artist
    params["country"] = country
    
    return params
  }
}

enum SectionModel {
  case searchResult([Track])
}

extension SectionModel: SectionModelType {
  
  typealias Item = Track

  var items: [Track] {
    switch self {
    case .searchResult(let tracks):
      return tracks.unique
    }
  }
  
  var artists: [String] {
    switch self {
    case .searchResult(let tracks):
      let artists = tracks.map {
        $0.artistName
      }.unique
      return artists
    }
  }
  
  init(original: SectionModel, items: [Track]) {
    switch original {
    case let .searchResult(tracks):
      self = .searchResult(tracks)
    }
  }
}
