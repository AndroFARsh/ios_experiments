// Created by Anton Kukhlevskyi on 2025-01-06.
// Copyright © 2025 Airbnb Inc. All rights reserved.

import SwiftUI

@main
struct iOSAuthHandelingSwiftUIApp: App {
  let coordinator = AppNanCoordinator(
    accessTokenStore: DefaultAccessTokenStore(),
    networkHandler: DefaultNetworkHandler()
  )

  var body: some Scene {
    WindowGroup {
      AppNanCoordinatorView(coordinator: coordinator)
    }
  }
}
