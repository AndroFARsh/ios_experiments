// Created by Anton Kukhlevskyi on 2025-01-03.
// Copyright © 2025 Airbnb Inc. All rights reserved.

import UIKit

extension UITextField {
  static func makeTextField(_ text: String? = nil, placeholder: String? = nil, delegate: UITextFieldDelegate? = nil) -> UITextField {
    let field = TextField()
    field.translatesAutoresizingMaskIntoConstraints = false
    field.layer.borderColor = UIColor.lightGray.cgColor
    field.layer.cornerRadius = 16
    field.layer.borderWidth = 1
    field.clipsToBounds = true
    field.text = text
    field.placeholder = placeholder
    field.delegate = delegate
    return field
  }

  static func makeEmailField(_ placeholder: String? = "Email", delegate: UITextFieldDelegate? = nil) -> UITextField {
    let field = makeTextField(placeholder: placeholder, delegate: delegate)
    field.translatesAutoresizingMaskIntoConstraints = false
    field.textContentType = .emailAddress
    field.keyboardType = .emailAddress
    field.autocapitalizationType = .none
    return field
  }

  static func makePasswordField(_ placeholder: String? = "Password", delegate: UITextFieldDelegate? = nil) -> UITextField {
    let field = makeTextField(placeholder: placeholder, delegate: delegate)
    field.translatesAutoresizingMaskIntoConstraints = false
    field.textContentType = .password
    field.autocapitalizationType = .none
    field.isSecureTextEntry = true
    return field
  }
}

extension UITextField {
  func setText(_ text: String? = nil) -> UITextField {
    self.translatesAutoresizingMaskIntoConstraints = false
    self.text = text
    return self
  }
}

class TextField : UITextField {
  var padding = UIEdgeInsets(
    top: 0,
    left: 10,
    bottom: 0,
    right: -1
  )

  override func textRect(forBounds bounds: CGRect) -> CGRect {
    let rect = super.textRect(forBounds: bounds)
    return rect.inset(by: padding)
  }

  override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
    let rect = super.placeholderRect(forBounds: bounds)
    return rect.inset(by: padding)
  }

  override func editingRect(forBounds bounds: CGRect) -> CGRect {
    let rect = super.editingRect(forBounds: bounds)
    return rect.inset(by: padding)
  }
}
