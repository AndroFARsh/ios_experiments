// Created by Anton Kukhlevskyi on 2025-01-04.
// Copyright © 2025 Airbnb Inc. All rights reserved.

import UIKit

class AppNavCoordinator {
  var window: UIWindow
  var networkHandler: NetworkHandler
  var accessTokenStore: AccessTokenStore

  var presenter: UINavigationController

  init(
    window: UIWindow,
    networkHandler: NetworkHandler,
    accessTokenStore: AccessTokenStore
  ) {
    self.window = window
    self.networkHandler = networkHandler
    self.accessTokenStore = accessTokenStore

    self.presenter = UINavigationController()

    self.presenter.view.backgroundColor = .white
    self.window.rootViewController = presenter
    self.window.makeKeyAndVisible()
  }

  func start() {
    cleanUp()

    if accessTokenStore.retrieve() != nil {
      showHomeScreen(animated: false)
    } else {
      showLoginScreen(animated: false)
    }
  }

  func logout() {
    accessTokenStore.delete()
    showLoginScreen()
  }
}

// MARK: Showing Screen
extension AppNavCoordinator {
  func showHomeScreen(animated: Bool = true) {
    let viewModel = HomeViewController.ViewModel(accessTokenStore: accessTokenStore, networkHandler: networkHandler, delegate: self)
    let controller = HomeViewController(viewModel: viewModel)
    presenter.setViewControllers([controller], animated: animated)
  }

  func showRegisterScreen(animated: Bool = true) {
    let viewModel = RegisterViewController.ViewModel(networkHandler: networkHandler, delegate: self)
    let controller = RegisterViewController(viewModel: viewModel)
    presenter.pushViewController(controller, animated: animated)
  }

  func showLoginScreen(animated: Bool = true) {
    let viewModel = LoginViewController.ViewModel(accessTokenStore: accessTokenStore, networkHandler: networkHandler, delegate: self)
    let controller = LoginViewController(viewModel: viewModel)
    presenter.setViewControllers([controller], animated: animated)
  }
}

// MARK: CleanUp before reinstall
extension AppNavCoordinator {
  static let appFreshLaunch = "com.demo.authApp.appFreshLaunch"

  private func cleanUp() {
    let userDefaults = UserDefaults.standard
    if !userDefaults.bool(forKey: AppNavCoordinator.appFreshLaunch) {
      accessTokenStore.delete()
      userDefaults.set(true, forKey: AppNavCoordinator.appFreshLaunch)
    }
  }
}

// MARK: NavCoordinator - LoginViewDelegate
extension AppNavCoordinator : LoginViewDelegate {
  func onLoginSuccessful() {
    showHomeScreen()
  }

  func onRegisterTapped() {
    showRegisterScreen()
  }
}

// MARK: NavCoordinator - RegisterViewDelegate
extension AppNavCoordinator : RegisterViewDelegate {
  func onRegisterSuccessful() {
    showHomeScreen()
  }
  func onLoginTapped() {
    showLoginScreen()
  }
}

// MARK: NavCoordinator - HomeViewDelegate
extension AppNavCoordinator : HomeViewDelegate {
  func onLogoutTapped() {
    logout()
  }
}
