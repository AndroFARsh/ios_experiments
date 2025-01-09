// Created by Anton Kukhlevskyi on 2025-01-07.
// Copyright © 2025 Airbnb Inc. All rights reserved.
import Combine
import SwiftUI

enum ScreenRoute: String, Identifiable {
  var id: String { return self.rawValue }

  case home
  case register
  case login
}

class AppNanCoordinator : ObservableObject {
  @Published var path: NavigationPath = NavigationPath()

  private let accessTokenStore: AccessTokenStore
  private let networkHandler: NetworkHandler

  private var isLoggedIn: Bool { accessTokenStore.retrieve() != nil }

  init(accessTokenStore: AccessTokenStore, networkHandler: NetworkHandler) {
    self.accessTokenStore = accessTokenStore
    self.networkHandler = networkHandler
  }

  func logout() {
    accessTokenStore.clean()
    path.removeLast(path.count)
  }

  @ViewBuilder
  func rootView() -> some View {
    if isLoggedIn {
      configureHomeView()
    } else {
      configureLoginView()
    }
  }

  @ViewBuilder
  func screenRouteToView(_ route: ScreenRoute) -> some View {
    switch route {
      case .home: configureHomeView()
      case .register: configureRegisterView()
      case .login: configureLoginView()
    }
  }
}

// MARK: - Configure Views
private extension AppNanCoordinator {
  @ViewBuilder
  func configureHomeView() -> some View {
    let viewModel = HomeView.ViewModel(accessTokenStore, networkHandler, self)
    HomeView(viewModel: viewModel)
  }

  @ViewBuilder
  func configureLoginView() -> some View {
    let viewModel = LoginView.ViewModel(accessTokenStore, networkHandler, self)
    LoginView(viewModel: viewModel)
  }

  @ViewBuilder
  func configureRegisterView() -> some View {
    let viewModel = RegisterView.ViewModel(networkHandler, self)
    RegisterView(viewModel: viewModel)
  }
}


// MARK: - HomeNavDelegate
extension AppNanCoordinator : HomeNavDelegate {
  func onLogOutTapped() {
    logout()
  }
}

// MARK: - LoginNavDelegate
extension AppNanCoordinator : LoginNavDelegate {
  func onRegisterTapped() {
    path.append(ScreenRoute.register)
  }
  
  func onLoginSuccessful() {
    path.removeLast(path.count)
  }
}


// MARK: - RegisterNavDelegate
extension AppNanCoordinator : RegisterNavDelegate {
  func onLoginTapped() {
    path.removeLast(path.count)
  }
}
