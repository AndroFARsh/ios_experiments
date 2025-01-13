// Created by Anton Kukhlevskyi on 2025-01-06.
// Copyright © 2025 Airbnb Inc. All rights reserved.

import SwiftUI

struct LoginView: View {

  @StateObject var viewModel: ViewModel

  var body: some View {
    LoadingContent(viewModel.progress.isLoading) {
      VStack {
        Spacer()
        EmailField(text: $viewModel.email)
        PasswordField(text: $viewModel.password)
          .padding(.bottom, 16)
        
        Button("Submit") { viewModel.onAction(.submit) }
          .buttonStyle(.borderedProminent)
        //.disabled(viewModel.$progress == .loading)
        
        Spacer()
        Button("Register") {
          viewModel.onAction(.toRegister)
        }
      }
      .padding(.horizontal, 40)
      .alert(
        "Error",
        isPresented: Binding(get: { viewModel.progress.isFailure }, set: {_ in }),
        actions: {
          Button("OK") {
            viewModel.progress = .unknown
          }
        },
        message: {
          if let error = viewModel.progress.error() { Text("Something went wrong:\n \(error)") }
        }
      )
    }
  }
}

