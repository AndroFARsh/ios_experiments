// Created by Anton Kukhlevskyi on 2025-01-07.
// Copyright © 2025 Airbnb Inc. All rights reserved.

import Foundation

protocol HomeNavDelegate: AnyObject {
  func onLogOutTapped()
}


extension HomeView {

  class ViewModel : ObservableObject {
    static let defaultInfoText = "Tap Fetch Button to load data"
    @Published var infoText = ViewModel.defaultInfoText
    @Published var progress: Async<String> = .unknown

    private let accessTokenStore: AccessTokenStore
    private let networkHandler: NetworkHandler
    private weak var navDelegate: HomeNavDelegate?

    init(_ accessTokenStore: AccessTokenStore, _ networkHandler: NetworkHandler, _ navDelegate: HomeNavDelegate?) {
      self.accessTokenStore = accessTokenStore
      self.networkHandler = networkHandler
      self.navDelegate = navDelegate
    }
  }
}

// MARK: Actions
extension HomeView.ViewModel {
  enum Action {
    case fetchData
    case resetData
    case logout
  }

  func onAction(_ action: Action) {
    switch action {
    case .fetchData: onFetchData()
    case .resetData: onRestoreDate()
    case .logout: navDelegate?.onLogOutTapped()
    }
  }

  private func onFetchData() {
    progress = .loading
    Task {
      do {
        let data = try await fetchData()
        infoText = data.message
        progress = .success(data.message)
      } catch let error {
        progress = .failure(error)
      }
    }
  }

  private func fetchData() async throws -> SecureFetchData {
    let route = NetworkRoutes.fetchSecureData
    let method = route.method

    guard let url = route.url else { throw ConfigurationError.nilObject }
    guard let accessToken = accessTokenStore.retrieve()?.accessToken else { throw ConfigurationError.nilObject }

    return try await networkHandler.request(
      url,
      httpMethod: method,
      accessToken: accessToken
    )
  }

  private func onRestoreDate() {
    infoText = HomeView.ViewModel.defaultInfoText
  }
}
