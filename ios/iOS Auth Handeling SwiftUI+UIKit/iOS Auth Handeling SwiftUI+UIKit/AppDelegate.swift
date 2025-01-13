// Created by Anton Kukhlevskyi on 2025-01-09.
// Copyright © 2025 Airbnb Inc. All rights reserved.

import SwiftUI
import Swinject

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

  lazy var assembler: Assembler = AppDelegate.createAssembler()

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    let appNavCoordinator = assembler.resolver.resolve<AppNavCoordinator>(AppNavCoordinator.self)
    appNavCoordinator?.start()
    return true
  }

  static func createAssembler() -> Assembler {
    return Container.builder()
      .register(CommonAssembly())
      .register(AppNavCoordinatorAssembly())
      .register(HomeAssembly())
      .register(LoginAssembly())
      .register(RegisterAssembly())
      .build()
  }
}

