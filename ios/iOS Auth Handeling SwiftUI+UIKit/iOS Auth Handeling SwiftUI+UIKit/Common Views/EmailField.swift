// Created by Anton Kukhlevskyi on 2025-01-06.
// Copyright © 2025 Airbnb Inc. All rights reserved.

import SwiftUI

struct EmailField: View {
  var placeholder: String = "Email"
  @Binding var text: String

  var body: some View {
    TextField(placeholder, text: $text)
      .textFieldStyle(DefaultTextFieldStyle())
      .textContentType(.emailAddress)
      .textInputAutocapitalization(.never)
  }
}

#Preview {
  EmailField(text: .constant(""))
}
