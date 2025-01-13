// Created by Anton Kukhlevskyi on 2025-01-06.
// Copyright © 2025 Airbnb Inc. All rights reserved.
import SwiftUI

struct RegisterView: View {
  @StateObject var viewModel: ViewModel

  var isLoading: Bool { viewModel.progress == .loading }
  var success: Bool { switch viewModel.progress {
    case .success(let res): res
    default: false
    }
  }
  var error: Error? {
    switch viewModel.progress {
      case .failure(let e): e
      default: nil
    }
  }

  var body: some View {
    LoadingContent(isLoading) {
      VStack {
        Spacer()
        EmailField(text: $viewModel.email)
        PasswordField(placeholder: "Password", text: $viewModel.password)
        PasswordField(placeholder: "Confirm Password", text: $viewModel.confirmPassword)
          .padding(.bottom, 16)

        Button("Submit") {
          viewModel.onAction(.submit)
        }
        .disabled(isLoading)
        .buttonStyle(.borderedProminent)

        Spacer()
        Button("Login") {
          viewModel.onAction(.toLogin)
        }
        .disabled(isLoading)
      }
      .padding(.horizontal, 40)
      .navigationTitle("Register")
      .alert(
        "Error",
        isPresented: Binding(get: { error != nil }, set: {_ in }),
        actions: {
          Button("OK") {
            viewModel.progress = .unknown
          }
        },
        message: {
          if let error { Text("Something went wrong:\n \(error)") }
        }
      )
      .alert(
        "Success",
        isPresented: Binding(get: { success }, set: {_ in}),
        actions: {
          Button("OK") {
            viewModel.progress = .unknown
            viewModel.onAction(.toLogin)
          }
        },
        message: {
          Text("Activation email sent to\n \(viewModel.email)")
        }
      )
    }
  }
}

