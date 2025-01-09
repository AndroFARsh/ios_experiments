// Created by Anton Kukhlevskyi on 2025-01-04.
// Copyright © 2025 Airbnb Inc. All rights reserved.

import Foundation

extension RegisterViewController {
  class ViewModel {
    var email: String? = nil
    var password: String? = nil
    var confirmPassword: String? = nil

    private let networkHandler: NetworkHandler
    private let delegate: RegisterViewDelegate

    init(networkHandler: NetworkHandler, delegate: RegisterViewDelegate) {
      self.networkHandler = networkHandler
      self.delegate = delegate
    }
  }
}

// MARK: Actions
extension RegisterViewController.ViewModel {
  enum Action {
    case submit(_ handler: ((_ result: Result<Bool, Error>) -> Void)? = nil)
    case toLogin

    var handler: ((_ result: Result<Bool, Error>) -> Void)? {
      if case let .submit(handler) = self { return handler }
      return nil
    }
  }

  func onAction(action: Action) {
    switch action {
    case .submit(_: let handler): onSubmitRegister(handler)
    case .toLogin: delegate.onLoginTapped()
    }
  }

  private func onSubmitRegister(_ handler: ((_ result: Result<Bool, Error>) -> Void)? = nil) {
    Task {
      do {
        try await submitRegister()
        await MainActor.run{ handler?(.success(true)) }
      } catch let error {
        await MainActor.run{ handler?(.failure(error)) }
      }
    }
  }

  private func submitRegister() async throws {
    guard let email, let password, let confirmPassword else { throw FormError.missingFields }
    guard !email.isEmpty, !password.isEmpty, password == confirmPassword else {
      print("Email and password are required")
      throw FormError.incorrectEntries
    }

    let route = NetworkRoutes.register
    let method = route.method
    guard let url = route.url else {
      print("No URL found")
      throw ConfigurationError.nilObject
    }

    let payload = [
      "email": email,
      "password": password,
      "confirm_password": confirmPassword,
    ]

    _ = try await networkHandler.request(
      url,
      payload: payload,
      httpMethod: method
    )
  }
}
