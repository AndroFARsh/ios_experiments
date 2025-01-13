// Created by Anton Kukhlevskyi on 2025-01-06.
// Copyright © 2025 Airbnb Inc. All rights reserved.

import SwiftUI

struct DefaultTextFieldStyle: TextFieldStyle {
  func _body(configuration: TextField<_Label>) -> some View {
    configuration
      .padding(.horizontal, 16)
      .padding(.vertical, 10)
      .clipShape(RoundedRectangle(cornerRadius: 16))
      .overlay {
        RoundedRectangle(cornerRadius: 16)
          .stroke(.black, lineWidth: 2)
      }
  }
}

#Preview {
  VStack {
    TextField("Placeholder", text: .constant(""))
      .textFieldStyle(DefaultTextFieldStyle())
      .padding(16)
  }
}
