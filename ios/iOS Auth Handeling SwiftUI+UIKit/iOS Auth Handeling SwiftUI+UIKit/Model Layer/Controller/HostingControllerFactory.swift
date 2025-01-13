
// Created by Anton Kukhlevskyi on 2025-01-09.
// Copyright © 2025 Airbnb Inc. All rights reserved.

import SwiftUI
import Swinject

class HostingControllerFactory {
  private var resolver:  Resolver

  init(_ resolver: Resolver) {
    self.resolver = resolver
  }

  func create<V: View>(_ type: V.Type) -> UIHostingController<V>? {
    guard let view = resolver.resolve<V>(type) else { return nil }
    return UIHostingController<V>(rootView: view)
  }
}
