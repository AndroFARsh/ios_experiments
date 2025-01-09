// Created by Anton Kukhlevskyi on 2025-01-07.
// Copyright © 2025 Airbnb Inc. All rights reserved.

import SwiftUI

struct AppNanCoordinatorView: View {

  @StateObject var coordinator: AppNanCoordinator

    var body: some View {
      NavigationStack(path: $coordinator.path) {
        coordinator.rootView()
          .navigationBarTitleDisplayMode(.inline)
          .navigationDestination(for: ScreenRoute.self) { route in
            coordinator.screenRouteToView(route)
          }
      }
    }
}

#Preview {
  let coordinator = AppNanCoordinator(
    accessTokenStore: DefaultAccessTokenStore(),
    networkHandler: DefaultNetworkHandler()
  )
  AppNanCoordinatorView(coordinator: coordinator)
}
