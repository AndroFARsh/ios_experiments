// Created by Anton Kukhlevskyi on 2025-01-03.
// Copyright © 2025 Airbnb Inc. All rights reserved.

import UIKit

// MARK: - AutoLayout Helpers (centring/sizing)
extension UIView {

  @discardableResult
  func addTo(_ view: UIView) -> UIView {
    translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(self)
    return self
  }

  @discardableResult
  func centerXOn(_ view: UIView) -> UIView {
    translatesAutoresizingMaskIntoConstraints = false

    centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    return self
  }

  @discardableResult
  func centerYOn(_ view: UIView) -> UIView {
    translatesAutoresizingMaskIntoConstraints = false

    centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    return self
  }

  @discardableResult
  func centerOn(_ view: UIView) -> UIView {
    translatesAutoresizingMaskIntoConstraints = false
    return centerXOn(view).centerYOn(view)
  }

  @discardableResult
  func setDefaultFiledSize(superview: UIView) -> UIView {
    translatesAutoresizingMaskIntoConstraints = false
    heightAnchor.constraint(equalToConstant: 40).isActive = true
    widthAnchor.constraint(equalTo: superview.widthAnchor, multiplier: 0.5).isActive = true
    return self
  }
}

// MARK: - AutoLayout Pinning Edges
extension UIView {
  @discardableResult
  func pinTop(toAnchor: NSLayoutYAxisAnchor, constant: CGFloat = 0) -> UIView {
    translatesAutoresizingMaskIntoConstraints = false
    topAnchor.constraint(equalTo: toAnchor, constant: constant).isActive = true
    return self
  }

  @discardableResult
  func pinBottom(toAnchor: NSLayoutYAxisAnchor, constant: CGFloat = 0) -> UIView {
    translatesAutoresizingMaskIntoConstraints = false
    bottomAnchor.constraint(equalTo: toAnchor, constant: constant).isActive = true
    return self
  }

  @discardableResult
  func pinLeading(toAnchor: NSLayoutXAxisAnchor, constant: CGFloat = 0) -> UIView {
    translatesAutoresizingMaskIntoConstraints = false
    leadingAnchor.constraint(equalTo: toAnchor, constant: constant).isActive = true
    return self
  }

  @discardableResult
  func pinTrailing(toAnchor: NSLayoutXAxisAnchor, constant: CGFloat = 0) -> UIView {
    translatesAutoresizingMaskIntoConstraints = false
    trailingAnchor.constraint(equalTo: toAnchor, constant: constant).isActive = true
    return self
  }
}

