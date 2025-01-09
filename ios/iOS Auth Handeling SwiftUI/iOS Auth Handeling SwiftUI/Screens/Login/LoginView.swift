// Created by Anton Kukhlevskyi on 2025-01-06.
// Copyright © 2025 Airbnb Inc. All rights reserved.

import SwiftUI

struct LoginView: View {

  @StateObject var viewModel: ViewModel
  
  var isLoading: Bool { viewModel.progress == .loading }
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
      .navigationTitle("Login")
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
    }
  }
}

#Preview {
  let viewModel = LoginView.ViewModel(DefaultAccessTokenStore(), DefaultNetworkHandler(), nil)
  LoginView(viewModel: viewModel)
}
