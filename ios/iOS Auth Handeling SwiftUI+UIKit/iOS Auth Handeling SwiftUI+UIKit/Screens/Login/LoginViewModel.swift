// Created by Anton Kukhlevskyi on 2025-01-07.
// Copyright © 2025 Airbnb Inc. All rights reserved.

import Foundation

protocol LoginNavDelegate: AnyObject {
  func onRegisterTapped()
  func onLoginSuccessful()
}

extension LoginView {
  class ViewModel: ObservableObject {
    @Published var email =  "test@gmail.com"
    @Published var password = "1234qwer!"
    @Published var progress: Async<Bool> = .unknown

//    var isLoading: Bool { progress == .loading }
//    var error: Error? {
//      guard progress as? Async<Bool>.failure(let e) else { nil }
//      return e
//    }
//      switch progress {
//        case .failure(let e): e
//        default: nil
//      }
//    }

    private var navDelegate: LoginNavDelegate
    private var networkHandler: NetworkHandler
    private var accessTokenStore: AccessTokenStore

    init(accessTokenStore: AccessTokenStore, networkHandler: NetworkHandler, navDelegate: LoginNavDelegate) {
      self.accessTokenStore = accessTokenStore
      self.networkHandler = networkHandler
      self.navDelegate = navDelegate
    }
  }
}

// MARK - Actions
extension LoginView.ViewModel {
  enum Action {
    case submit
    case toHome
    case toRegister
  }

  func onAction(_ action: Action) {
    switch action {
      case .submit: onSubmitTapped()
      case .toHome: navDelegate.onLoginSuccessful()
      case .toRegister: navDelegate.onRegisterTapped()
    }
  }

  private func onSubmitTapped() {
    progress = .loading
    Task {
      do {
        let token = try await submitLogin()
        await MainActor.run {
          if accessTokenStore.store(token) {
            progress = .success(true)
            onAction(.toHome)
          } else {
            progress = .failure(KeyChainError.saveFailed)
          }
        }
      } catch let error {
        await MainActor.run { progress = .failure(error) }
      }
    }
  }

  private func submitLogin() async throws -> AccessToken {
    let route = NetworkRoutes.accessToken
    let method = route.method

    guard let url = route.url else { throw ConfigurationError.nilObject }
    guard !email.isEmpty, !password.isEmpty else { throw FormError.missingFields }

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
