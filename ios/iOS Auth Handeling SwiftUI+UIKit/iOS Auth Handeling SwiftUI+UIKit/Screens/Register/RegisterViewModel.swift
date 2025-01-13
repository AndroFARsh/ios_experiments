// Created by Anton Kukhlevskyi on 2025-01-07.
// Copyright © 2025 Airbnb Inc. All rights reserved.

import Foundation

protocol RegisterNavDelegate: AnyObject {
  func onLoginTapped()
}

extension RegisterView {

  class ViewModel : ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var progress: Async<Bool> = .unknown

    private weak var navDelegate: RegisterNavDelegate?
    private var networkHandler: NetworkHandler

    init(networkHandler: NetworkHandler, navDelegate: RegisterNavDelegate) {
      self.networkHandler = networkHandler
      self.navDelegate = navDelegate
    }
  }
}

// MARK: Actions
extension RegisterView.ViewModel {
  enum Action {
    case submit
    case toLogin
  }

  func onAction(_ action: Action) {
    switch action {
    case .submit: onSubmitTapped()
    case .toLogin: navDelegate?.onLoginTapped()
    }
  }

  private func onSubmitTapped() {
    progress = .loading
    Task {
      do {
        try await submitRegistration()
        await MainActor.run { progress = .success(true) }
      } catch let error {
        await MainActor.run { progress = .failure(error) }
      }
    }
  }

  private func submitRegistration() async throws {
    let route = NetworkRoutes.register
    let method = route.method

    guard let url = route.url else { throw ConfigurationError.nilObject }
    guard !email.isEmpty, !password.isEmpty, !confirmPassword.isEmpty else { throw FormError.missingFields }
    guard password == confirmPassword else { throw FormError.incorrectEntries }

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
