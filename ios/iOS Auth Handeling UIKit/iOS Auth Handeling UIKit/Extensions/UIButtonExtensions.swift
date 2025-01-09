// Created by Anton Kukhlevskyi on 2025-01-03.
// Copyright © 2025 Airbnb Inc. All rights reserved.

import UIKit

extension UIButton {
  static func makeButton(_ title: String, configuration: UIButton.Configuration = UIButton.Configuration.plain()) -> UIButton {
    let button = UIButton(configuration: configuration)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle(title, for: .normal)
    return button
  }

  func registerAction(for controlEvents: UIControl.Event = .touchUpInside, _ closure: @escaping()->()) -> UIButton {
    self.translatesAutoresizingMaskIntoConstraints = false
    self.addAction(UIAction { (action: UIAction) in closure() }, for: controlEvents)
    return self
  }
 }
