// Created by Anton Kukhlevskyi on 2025-01-03.
// Copyright © 2025 Airbnb Inc. All rights reserved.

import UIKit

extension LoginViewController {
  class ViewModel {
    var email: String? = nil
    var password: String? = nil

    private let accessTokenStore: AccessTokenStore
    private let networkHandler: NetworkHandler
    private let delegate: LoginViewDelegate

    init(accessTokenStore: AccessTokenStore, networkHandler: NetworkHandler, delegate: LoginViewDelegate) {
      self.accessTokenStore = accessTokenStore
      self.networkHandler = networkHandler
      self.delegate = delegate
    }
  }
}


// MARK: Actions
extension LoginViewController.ViewModel {
  enum Action {
    case submit(_ handler: ((Result<AccessToken, Error>)->Void)?)
    case toRegister
    case toHome
  }

  func onAction(_ action: Action) {
    switch action {
    case .submit(_: let handler): onSubmitTapped(handler)
    case .toRegister: delegate.onRegisterTapped()
    case .toHome: delegate.onLoginSuccessful()
    }
  }

  func onSubmitTapped(_ handler: ((Result<AccessToken, Error>)->Void)?) {
    Task {
      do {
        let accessToken = try await performLogin()
        accessTokenStore.save(accessToken)
        await MainActor.run { handler?(.success(accessToken)) }
      } catch let error {
        await MainActor.run { handler?(.failure(error)) }
      }
    }
  }

  func performLogin() async throws -> AccessToken {
    guard let email, let password else { throw FormError.missingFields }
    guard !email.isEmpty, !password.isEmpty else {
      print("Email and password are required")
      throw FormError.incorrectEntries
    }

    let route = NetworkRoutes.accessToken
    guard let url = route.url else {
      print("No URL found")
      throw ConfigurationError.nilObject
    }
    let method = route.method
    let payload = [
      "username": email,
      "password": password,
    ]

    return try await networkHandler.request(
      url,
      payload: payload,
      httpMethod: method
    )
  }
}
