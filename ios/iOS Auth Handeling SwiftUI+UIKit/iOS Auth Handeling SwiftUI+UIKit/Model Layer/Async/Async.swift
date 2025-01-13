// Created by Anton Kukhlevskyi on 2025-01-07.
// Copyright © 2025 Airbnb Inc. All rights reserved.

import Foundation

enum Async<Success: Equatable> : Equatable {
  case unknown
  case loading
  case success(Success)
  case failure(Error)

  static func == (l: Async<Success>, r: Async<Success>) -> Bool {
    switch (l,r) {
    case (.unknown, .unknown): true
    case (.loading, .loading): true
    case (.failure(let lError), .failure(let rError)): lError.localizedDescription == rError.localizedDescription
    case (.success(let lData), .success(let rData)): lData == rData
    default: false
    }
  }

  var isLoading: Bool {
    switch self {
    case .loading: true
    default: false
    }
  }
  var isSuccess: Bool {
    switch self {
    case .success(_): true
    default: false
    }
  }
  var isFailure: Bool {
    switch self {
    case .failure(_): true
    default: false
    }
  }

  func error() -> Error? {
    switch self {
      case .failure(let error): error
      default: nil
    }
  }

  func data() -> Success? {
    switch self {
    case .success(let data): data
      default: nil
    }
  }
}
