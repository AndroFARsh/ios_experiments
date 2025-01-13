// Created by Anton Kukhlevskyi on 2025-01-06.
// Copyright © 2025 Airbnb Inc. All rights reserved.

import SwiftUI

struct PasswordField: View {
  var placeholder: String = "Password"
  @Binding var text: String

  var body: some View {
    SecureField(placeholder, text: $text)
      .textFieldStyle(DefaultTextFieldStyle())
      .textInputAutocapitalization(.never)
  }
}

#Preview {
  PasswordField(placeholder: "Password", text: .constant(""))
}
