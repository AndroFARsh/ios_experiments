// Created by Anton Kukhlevskyi on 2025-01-06.
// Copyright © 2025 Airbnb Inc. All rights reserved.

import Foundation

struct AccessToken : Codable {
  var accessToken: String
  var refreshToken: String

  enum CodingKeys: String, CodingKey {
    case accessToken = "access"
    case refreshToken = "refresh"
  }
}
