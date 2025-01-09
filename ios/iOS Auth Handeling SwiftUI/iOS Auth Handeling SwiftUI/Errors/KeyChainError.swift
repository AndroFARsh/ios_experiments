// Created by Anton Kukhlevskyi on 2025-01-06.
// Copyright © 2025 Airbnb Inc. All rights reserved.

import Foundation

enum KeyChainError : Error {
  case saveFailed
  case retrieveFailed
  case deleteFailed
}
