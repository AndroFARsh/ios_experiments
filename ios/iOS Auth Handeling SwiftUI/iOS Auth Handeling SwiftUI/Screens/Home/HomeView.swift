// Created by Anton Kukhlevskyi on 2025-01-06.
// Copyright © 2025 Airbnb Inc. All rights reserved.

import SwiftUI

struct HomeView: View {
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
        Text(viewModel.infoText)
          .multilineTextAlignment(.center)
          .padding(.bottom, 16)
        Button("Fetch Secure Data") {
          viewModel.onAction(.fetchData)
        }
        .buttonStyle(.borderedProminent)
        Button("Reset Data") {
          viewModel.onAction(.resetData)
        }

        Spacer()
        Button("Logout") {
          viewModel.onAction(.logout)
        }
      }
      .padding(.horizontal, 40)
      .navigationTitle("Home")
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
  let viewModel = HomeView.ViewModel(DefaultAccessTokenStore(), DefaultNetworkHandler(), nil)
  HomeView(viewModel: viewModel)
}
