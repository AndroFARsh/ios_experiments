// Created by Anton Kukhlevskyi on 2025-01-09.
// Copyright © 2025 Airbnb Inc. All rights reserved.

import Swinject
import SwinjectAutoregistration

class CommonAssembly : Assembly {
  func assemble(container: Container) {
    container.register(Resolver.self) { resolver in resolver }
    
    container.autoregister(NetworkHandler.self, initializer: DefaultNetworkHandler.init).inObjectScope(.container)
    container.autoregister(AccessTokenStore.self, initializer: DefaultAccessTokenStore.init).inObjectScope(.container)
    container.autoregister(HostingControllerFactory.self, initializer: HostingControllerFactory.init).inObjectScope(.container)
  }
}
