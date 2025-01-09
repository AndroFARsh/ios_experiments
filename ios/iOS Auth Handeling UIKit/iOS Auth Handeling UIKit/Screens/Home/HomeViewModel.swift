// Created by Anton Kukhlevskyi on 2025-01-04.
// Copyright © 2025 Airbnb Inc. All rights reserved.

import Combine
import Foundation

extension HomeViewController {
  class ViewModel {
    static let defaultInfoText: String = "Tap fetch button to fetch secured data"

    @Published var infoText: String = ViewModel.defaultInfoText

    private let accessTokenStore: AccessTokenStore
    private let networkHandler: NetworkHandler
    private let delegate: HomeViewDelegate

    init(accessTokenStore: AccessTokenStore, networkHandler: NetworkHandler, delegate: HomeViewDelegate) {
      self.accessTokenStore = accessTokenStore
      self.networkHandler = networkHandler
      self.delegate = delegate
    }
  }
}

// MARK: Actions
extension HomeViewController.ViewModel {
  enum Action {
    case fetchData(_ handler: ((Result<SecureFetchData, Error>)->Void)?)
    case restoreData
    case logout
  }

  func onAction(_ action: Action) {
    switch action {
    case .fetchData(_: let handler): onFetchData(handler)
    case .restoreData: infoText = HomeViewController.ViewModel.defaultInfoText
    case .logout: delegate.onLogoutTapped()
    }
  }

  private func onFetchData(_ handler: ((Result<SecureFetchData, Error>)->Void)? = nil) {
    Task {
      do {
        let data = try await fetchData()
        infoText = data.message
        await MainActor.run { handler?(.success(data)) }
      } catch let error {
        await MainActor.run { handler?(.failure(error)) }
      }
    }
  }

  private func fetchData() async throws -> SecureFetchData {
    let route = NetworkRoutes.fetchSecureData
    let method = route.method
    guard let url = route.url,
          let accessToken = accessTokenStore.retrieve()?.accessToken else {
      print("No URL or Access Token found")
      throw ConfigurationError.nilObject
    }

    return try await networkHandler.request(
      url,
      httpMethod: method,
      accessToken: accessToken
    )
  }
}
