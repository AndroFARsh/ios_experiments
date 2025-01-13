// Created by Anton Kukhlevskyi on 2025-01-09.
// Copyright © 2025 Airbnb Inc. All rights reserved.

import Swinject
import AuthenticationServices

class AppNavCoordinatorAssembly : Assembly {

  func assemble(container: Container) {
    container.register(UIWindow.self) { _ in UIWindow(frame: UIScreen.main.bounds) }
      .inObjectScope(.container)

    container.autoregister(AppNavCoordinator.self, initializer: AppNavCoordinator.init)
      .implements(HomeNavDelegate.self, RegisterNavDelegate.self, LoginNavDelegate.self)
      .inObjectScope(.container)
  }
}
