// Created by Anton Kukhlevskyi on 2025-01-06.
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
    contentType: String?,
    accessToken: String?
  ) async throws -> Data

  func request<ResponseType: Decodable>(
    _ url: URL,
    payload: Any?,
    responseType: ResponseType.Type,
    httpMethod: HttpMethod,
    contentType: String?,
    accessToken: String?
  ) async throws -> ResponseType
}

// MARK: Default Args
extension NetworkHandler {
  func request(
    _ url: URL,
    payload: Any? = nil,
    httpMethod: HttpMethod = HttpMethod.get,
    contentType: String? = ContentType.json.rawValue,
    accessToken: String? = nil
  ) async throws -> Data {
    return try await request(url, payload: payload, httpMethod: httpMethod, contentType: contentType, accessToken: accessToken)
  }

  func request<ResponseType: Decodable>(
    _ url: URL,
    payload: Any? = nil,
    responseType: ResponseType.Type = ResponseType.self,
    httpMethod: HttpMethod = HttpMethod.get,
    contentType: String? = ContentType.json.rawValue,
    accessToken: String? = nil
  ) async throws -> ResponseType {
    return try await request<ResponseType>(url, payload: payload, responseType: responseType, httpMethod: httpMethod, contentType: contentType, accessToken: accessToken)
  }
}

// MARK: Default Implementation of NetworkHandler
class DefaultNetworkHandler : NetworkHandler {
  func request<ResponseType>(
    _ url: URL,
    payload: Any? = nil,
    responseType: ResponseType.Type = ResponseType.self,
    httpMethod: HttpMethod = HttpMethod.get,
    contentType: String? = ContentType.json.rawValue,
    accessToken: String? = nil
  ) async throws -> ResponseType where ResponseType : Decodable {
    let data = try await request(
      url,
      payload: payload,
      httpMethod: httpMethod,
      contentType: contentType,
      accessToken: accessToken
    )

    return try JSONDecoder().decode(ResponseType.self, from: data)
  }
  
  func request(
    _ url: URL,
    payload: Any? = nil,
    httpMethod: HttpMethod = HttpMethod.get,
    contentType: String? = ContentType.json.rawValue,
    accessToken: String? = nil
  ) async throws -> Data {
    var urlRequest = makeUrlRequest(
      url,
      httpMethod: httpMethod,
      contentType: contentType,
      accessToken: accessToken
    )

    if let payload, let httpBody = try? JSONSerialization.data(withJSONObject: payload) {
      urlRequest.httpBody = httpBody
    } else if let payload {
      print("Could not serialize object into JDON data: \(payload)")
      throw ConfigurationError.nilObject
    }

    let (data, response) = try await URLSession.shared.data(for: urlRequest)
    guard let httpResponse = response as? HTTPURLResponse else {
      print("Could not create HTTPURLResponse for: \(urlRequest.url?.absoluteString ?? "nil")")
      throw NetworkError.noResponse
    }

    let statusCode = httpResponse.statusCode
    guard 200...299 ~= statusCode else {
      throw NetworkError.failedStatusCodeResponseData(statusCode, data)
    }

    return data
  }

  func makeUrlRequest(
    _ url: URL,
    httpMethod: HttpMethod = HttpMethod.get,
    contentType: String? = ContentType.json.rawValue,
    accessToken: String? = nil
  ) -> URLRequest {
    var urlRequest = URLRequest(url: url)
    urlRequest.httpMethod = httpMethod.rawValue
    if let contentType {
      urlRequest.addValue(contentType, forHTTPHeaderField: "Content-Type")
      if contentType.range(of: "json") != nil {
        urlRequest.addValue(contentType, forHTTPHeaderField: "Accept")
      }
    }

    if let accessToken {
      urlRequest.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
    }

    return urlRequest
  }
}
