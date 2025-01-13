// Created by Anton Kukhlevskyi on 2025-01-07.
// Copyright © 2025 Airbnb Inc. All rights reserved.
import Combine
import SwiftUI
import Swinject

enum ScreenRoute: String, Identifiable {
  var id: String { return self.rawValue }

  case home
  case register
  case login
}

class AppNavCoordinator {

  private var isLoggedIn: Bool { accessTokenStore.retrieve() != nil }

  private var accessTokenStore: AccessTokenStore
  private var window: UIWindow
  private var controllerFactory: HostingControllerFactory

  private var presenter: UINavigationController

  init(accessTokenStore: AccessTokenStore, window: UIWindow, controllerFactory: HostingControllerFactory) {
    self.accessTokenStore = accessTokenStore
    self.controllerFactory = controllerFactory
    self.window =  window

    self.presenter = UINavigationController()
    self.presenter.view.backgroundColor = .white
    self.window.rootViewController = self.presenter
    self.window.makeKeyAndVisible()
  }

  func logout() {
    accessTokenStore.clean()
    showLoginScreen()
  }

  func start() {
    cleanUp()

    if isLoggedIn {
      showHomeScreen(animated: false)
    } else {
      showLoginScreen(animated: false)
    }
  }
}

// MARK: CleanUp before reinstall
extension AppNavCoordinator {
  static let appFreshLaunch = "com.demo.authApp.appFreshLaunch"

  private func cleanUp() {
    let userDefaults = UserDefaults.standard
    if !userDefaults.bool(forKey: AppNavCoordinator.appFreshLaunch) {
      accessTokenStore.clean()
      userDefaults.set(true, forKey: AppNavCoordinator.appFreshLaunch)
    }
  }
}

// MARK: - Configure Screens
private extension AppNavCoordinator {
  func showHomeScreen(animated: Bool = true) {
    if let controller = controllerFactory.create(HomeView.self) {
      presenter.setViewControllers([controller], animated: animated)
    }
  }

  func showLoginScreen(animated: Bool = true) {
    if let controller = controllerFactory.create(LoginView.self) {
      presenter.setViewControllers([controller], animated: animated)
    }
  }

  func showRegisterScreen(animated: Bool = true) {
    if let controller = controllerFactory.create(RegisterView.self) {
      presenter.pushViewController(controller, animated: animated)
    }
  }
}


// MARK: - HomeNavDelegate
extension AppNavCoordinator : HomeNavDelegate {
  func onLogOutTapped() {
    logout()
  }
}

// MARK: - LoginNavDelegate
extension AppNavCoordinator : LoginNavDelegate {
  func onRegisterTapped() {
    showRegisterScreen()
  }
  
  func onLoginSuccessful() {
    showHomeScreen()
  }
}


// MARK: - RegisterNavDelegate
extension AppNavCoordinator : RegisterNavDelegate {
  func onLoginTapped() {
    showLoginScreen()
  }
}
