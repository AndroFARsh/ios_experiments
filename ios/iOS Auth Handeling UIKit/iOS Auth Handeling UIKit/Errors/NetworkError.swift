// Created by Anton Kukhlevskyi on 2025-01-06.
// Copyright © 2025 Airbnb Inc. All rights reserved.

import Foundation

enum NetworkError : Error {
  case userError(String)
  case dataError(String)
  case encodingError
  case decodingError
  case failedStatusCode(String)
  case failedStatusCodeResponseData(Int, Data)
  case noResponse

  var statusCodeResponseData: (Int, Data)? {
    if case let .failedStatusCodeResponseData(statusCode, responseData) = self {
      return (statusCode, responseData)
    }
    return nil
  }
}
