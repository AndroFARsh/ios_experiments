// Created by Anton Kukhlevskyi on 2025-01-07.
// Copyright © 2025 Airbnb Inc. All rights reserved.

import Foundation

enum HttpMethod: String {
  case get = "GET"
  case post = "POST"
  case put = "PUT"
  case delete = "DELETE"
}

enum ContentType: String {
  case json = "application/json; character=utf-8"
}

protocol NetworkHandler {
  func request(
    _ url: URL,
    payload: Any?,
    httpMethod: HttpMethod,
    contentType: ContentType?,
    accessToken: String?
  ) async throws -> Data
}


extension NetworkHandler {
  func request(
    _ url: URL,
    payload: Any? = nil,
    httpMethod: HttpMethod = HttpMethod.get,
    contentType: ContentType? = ContentType.json,
    accessToken: String? = nil
  ) async throws -> Data {
    return try await request(url, payload: payload, httpMethod: httpMethod, contentType: contentType, accessToken: accessToken)
  }

  func request<ResponseType: Decodable>(
    _ url: URL,
    responseType: ResponseType.Type = ResponseType.self,
    payload: Any? = nil,
    httpMethod: HttpMethod = HttpMethod.get,
    contentType: ContentType? = ContentType.json,
    accessToken: String? = nil
  ) async throws -> ResponseType {
    let data = try await request(url, payload: payload, httpMethod: httpMethod, contentType: contentType, accessToken: accessToken)
    return try JSONDecoder().decode(responseType, from: data)
  }
}

class DefaultNetworkHandler : NetworkHandler {
  func request(
    _ url: URL,
    payload: Any?,
    httpMethod: HttpMethod,
    contentType: ContentType?,
    accessToken: String?
  ) async throws -> Data {
    var request = makeRequest(url, httpMethod: httpMethod, contentType: contentType?.rawValue, accessToken: accessToken)
    if let payload, let httpBody = try? JSONSerialization.data(withJSONObject: payload) {
      request.httpBody = httpBody
    } else if let payload {
      print("Could not serialize object into JDON data: \(payload)")
      throw ConfigurationError.nilObject
    }

    let (data, response) = try await URLSession.shared.data(for: request)
    guard let httpResponse = response as? HTTPURLResponse else {
      print("Could not create HTTPURLResponse for: \(request.url?.absoluteString ?? "nil")")
      throw NetworkError.noResponse
    }

    let statusCode = httpResponse.statusCode
    guard 200...299 ~= statusCode else {
      throw NetworkError.failedStatusCodeResponseData(statusCode, data)
    }

    return data
  }

  func makeRequest(
    _ url: URL,
    httpMethod: HttpMethod,
    contentType: String?,
    accessToken: String?
  ) -> URLRequest {
    var request = URLRequest(url: url)
    request.httpMethod = httpMethod.rawValue
    if let contentType {
      request.addValue(contentType, forHTTPHeaderField: "Content-Type")
      if contentType.range(of: "json") != nil {
        request.addValue(contentType, forHTTPHeaderField: "Accept")
      }
    }

    if let accessToken {
      request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
    }
    return request
  }

}


