// Created by Anton Kukhlevskyi on 2025-01-06.
// Copyright © 2025 Airbnb Inc. All rights reserved.

import SwiftUI

struct LoadingContent<Content: View>: View {
  let isLoading: Bool
  let content: Content

  init(_ isLoading: Bool = false, _ content: @escaping () -> Content) {
    self.isLoading = isLoading
    self.content = content()
  }

  var body: some View {
    ZStack {
      content

      if (isLoading) {
        VStack {
          ProgressView()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.opacity(0.2))
      }
    }
  }
}

#Preview {
  LoadingContent(false) {
    PasswordField(placeholder: "Password", text: .constant(""))
  }
}
