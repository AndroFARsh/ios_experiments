// Created by Anton Kukhlevskyi on 2025-01-03.
// Copyright © 2025 Airbnb Inc. All rights reserved.

import UIKit

extension UITextView {
  static func makeTextView(_ text: String? = nil) -> UITextView {
    let view = UITextView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.textColor = .black
    view.font = .systemFont(ofSize: 14)
    view.textAlignment = .center
    view.text = text
    return view
  }
}
