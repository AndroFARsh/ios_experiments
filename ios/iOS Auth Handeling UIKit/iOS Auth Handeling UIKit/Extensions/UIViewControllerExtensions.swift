// Created by Anton Kukhlevskyi on 2025-01-03.
// Copyright © 2025 Airbnb Inc. All rights reserved.

import UIKit

extension UIViewController {
  func showOkAlert(title: String?, message: String? = nil, completion: (() -> Void)? = nil) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let okAction = UIAlertAction(title: "OK", style: .cancel) { _ in
      completion?()
    }
    alert.addAction(okAction)
    present(alert, animated: true)
  }
}
