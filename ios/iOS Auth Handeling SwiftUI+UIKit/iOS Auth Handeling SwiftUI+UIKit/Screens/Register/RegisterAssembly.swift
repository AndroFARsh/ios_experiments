// Created by Anton Kukhlevskyi on 2025-01-09.
// Copyright © 2025 Airbnb Inc. All rights reserved.

import Swinject
import AuthenticationServices

class RegisterAssembly : Assembly {

  func assemble(container: Container) {
    container.register(RegisterView.self) { c in
      RegisterView(viewModel: c.resolve(RegisterView.ViewModel.self)!)
    }
    container.autoregister(RegisterView.ViewModel.self, initializer: RegisterView.ViewModel.init).inObjectScope(.weak)
  }
}
