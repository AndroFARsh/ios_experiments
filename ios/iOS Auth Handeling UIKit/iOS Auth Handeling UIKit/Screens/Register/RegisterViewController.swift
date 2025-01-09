// Created by Anton Kukhlevskyi on 2025-01-04.
// Copyright © 2025 Airbnb Inc. All rights reserved.

import UIKit

class RegisterViewController : UIViewController {

  private lazy var emailTextFiled: UITextField = .makeEmailField("Email", delegate: self)
  private lazy var passwordTextFiled: UITextField = .makePasswordField("Password", delegate: self)
  private lazy var confirmPasswordTextFiled: UITextField = .makePasswordField("Confirm Password", delegate: self)
  private lazy var submitButton: UIButton = .makeButton("Submit", configuration: UIButton.Configuration.filled()).registerAction(self.onSubmitTapped)
  private lazy var loginButton: UIButton = .makeButton("Log In").registerAction(self.onLoginTapped)

  private let viewModel: ViewModel?

  init(viewModel: ViewModel?) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not used")
  }
}

// MARK: - Lifecycle
extension RegisterViewController {
  override func viewDidLoad() {
    super.viewDidLoad()

    setupViews()
  }
}

// MARK: - View Setup/Configuration
private extension RegisterViewController {
  func setupViews() {
    title = "Register"
    view.backgroundColor = .white

    emailTextFiled
      .setText(viewModel?.email)
      .addTo(view)
      .centerOn(view)
      .setDefaultFiledSize(superview: view)

    passwordTextFiled
      .setText(viewModel?.password)
      .addTo(view)
      .centerXOn(view)
      .pinTop(toAnchor: emailTextFiled.bottomAnchor, constant: 12)
      .setDefaultFiledSize(superview: view)

    confirmPasswordTextFiled
      .setText(viewModel?.confirmPassword)
      .addTo(view)
      .centerXOn(view)
      .pinTop(toAnchor: passwordTextFiled.bottomAnchor, constant: 12)
      .setDefaultFiledSize(superview: view)

    submitButton
      .addTo(view)
      .centerXOn(view)
      .pinTop(toAnchor: confirmPasswordTextFiled.bottomAnchor, constant: 12)

    loginButton
      .addTo(view)
      .pinTop(toAnchor: view.safeAreaLayoutGuide.topAnchor)
      .pinTrailing(toAnchor: view.safeAreaLayoutGuide.trailingAnchor, constant: -12)

  }
}

// MARK: - Actions
extension RegisterViewController {
  @objc func onSubmitTapped() {
    viewModel?.email = emailTextFiled.text
    viewModel?.password = passwordTextFiled.text
    viewModel?.confirmPassword = confirmPasswordTextFiled.text
    viewModel?.onAction(action: .submit(self.onRegisterResult))
  }

  func onLoginTapped() {
    viewModel?.onAction(action: .toLogin)
  }

  private func onRegisterResult(result: Result<Bool, Error>) {
    switch result {
    case .success(_): showOkAlert(title: "Registered", message: "Activation email sent to \(viewModel?.email ?? "")") {
      self.viewModel?.onAction(action: .toLogin)
    }
    case .failure(_: let error): showOkAlert(title: "Error", message: error.localizedDescription)
    }
  }
}

// MARK: - UITextFieldDelegate
extension RegisterViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if textField == emailTextFiled {
      passwordTextFiled.becomeFirstResponder()
    } else if textField == passwordTextFiled {
      confirmPasswordTextFiled.becomeFirstResponder()
    } else {
      view.endEditing(true)
    }
    return false
  }
}


#Preview {
  RegisterViewController(viewModel: nil)
}
