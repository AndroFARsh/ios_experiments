// Created by Anton Kukhlevskyi on 2025-01-09.
// Copyright © 2025 Airbnb Inc. All rights reserved.

import Swinject
import AuthenticationServices

class HomeAssembly : Assembly {

  func assemble(container: Container) {
    container.register(HomeView.self) { c in
      HomeView(viewModel: c.resolve(HomeView.ViewModel.self)!)
    }
    container.autoregister(HomeView.ViewModel.self, initializer: HomeView.ViewModel.init).inObjectScope(.weak)
  }
}
