// Created by Anton Kukhlevskyi on 2025-01-04.
// Copyright © 2025 Airbnb Inc. All rights reserved.

import Foundation

protocol Delegate : Any {
}

protocol RegisterViewDelegate : AnyObject{
  func onLoginTapped()
}
