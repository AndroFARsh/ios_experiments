// Created by Anton Kukhlevskyi on 2025-01-07.
// Copyright © 2025 Airbnb Inc. All rights reserved.

import Foundation

enum NetworkRoutes {
  case register
  case accessToken
  case fetchSecureData

  private static let baseUrl = "http://127.0.0.1:8000"

  var url: URL? {
    let path: String = switch self {
      case .register: "\(NetworkRoutes.baseUrl)/api/register/"
      case .accessToken: "\(NetworkRoutes.baseUrl)/api/auth/token/"
      case .fetchSecureData: "\(NetworkRoutes.baseUrl)/api/login_data/"
    }
    return URL(string: path)
  }

  var method: HttpMethod {
    switch self {
      case .register, .accessToken: .post
      case .fetchSecureData: .get
    }
  }
}
