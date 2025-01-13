// Created by Anton Kukhlevskyi on 2025-01-06.
// Copyright © 2025 Airbnb Inc. All rights reserved.

import SwiftUI

struct HomeView: View {
  @StateObject var viewModel: ViewModel

  var body: some View {
    LoadingContent(viewModel.progress.isLoading) {
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
        isPresented: Binding(get: { viewModel.progress.isFailure }, set: {_ in}),
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
