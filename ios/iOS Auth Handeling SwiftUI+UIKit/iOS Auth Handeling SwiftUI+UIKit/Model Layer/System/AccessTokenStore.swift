// Created by Anton Kukhlevskyi on 2025-01-06.
// Copyright © 2025 Airbnb Inc. All rights reserved.

import Foundation
import Security

protocol AccessTokenStore {
  @discardableResult
  func store(_ token: AccessToken) -> Bool

  func retrieve() -> AccessToken?

  @discardableResult
  func clean() -> Bool
}

struct DefaultAccessTokenStore : AccessTokenStore {
  private let accountKey = "com.demo.auth_class_token"

  @discardableResult
  func store(_ token: AccessToken) -> Bool {
    clean()
    guard let data = try? JSONEncoder().encode(token) else { return false }
    let query = [
      kSecClass: kSecClassGenericPassword,
      kSecAttrAccount: accountKey,
      kSecValueData: data
    ] as [CFString : Any]
    let status = SecItemAdd(query as CFDictionary, nil)
    return status == errSecSuccess
  }

  func retrieve() -> AccessToken? {
    let query = [
      kSecClass: kSecClassGenericPassword,
      kSecAttrAccount: accountKey,
      kSecReturnData: true,
      kSecMatchLimit: kSecMatchLimitOne
    ] as [CFString : Any]

    var item: CFTypeRef?
    let status = SecItemCopyMatching(query as CFDictionary, &item)

    guard status == errSecSuccess else { return nil }
    guard let data = item as? Data else { return nil }
    guard let token = try? JSONDecoder().decode(AccessToken.self, from: data) else { return nil }

    return token
  }

  @discardableResult
  func clean() -> Bool {
    let query = [
      kSecClass: kSecClassGenericPassword,
      kSecAttrAccount: accountKey
    ] as [CFString : Any]
    let status = SecItemDelete(query as CFDictionary)
    return status == errSecSuccess
  }

}
