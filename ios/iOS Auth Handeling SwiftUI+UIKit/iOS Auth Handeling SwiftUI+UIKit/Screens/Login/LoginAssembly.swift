// Created by Anton Kukhlevskyi on 2025-01-09.
// Copyright © 2025 Airbnb Inc. All rights reserved.

import Swinject
import AuthenticationServices

class LoginAssembly : Assembly {

  func assemble(container: Container) {
    container.register(LoginView.self) { c in
      LoginView(viewModel: c.resolve(LoginView.ViewModel.self)!)
    }
    container.autoregister(LoginView.ViewModel.self, initializer: LoginView.ViewModel.init).inObjectScope(.weak)
  }
}
