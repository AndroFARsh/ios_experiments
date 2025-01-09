// Created by Anton Kukhlevskyi on 2025-01-03.
// Copyright © 2025 Airbnb Inc. All rights reserved.

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

  var appNavCoordinator: AppNavCoordinator!

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    appNavCoordinator = AppNavCoordinator(
      window: UIWindow(frame: UIScreen.main.bounds),
      networkHandler: DefaultNetworkHandler(),
      accessTokenStore: DefaultAccessTokenStore()
    )
    appNavCoordinator.start()
    return true
  }
}

