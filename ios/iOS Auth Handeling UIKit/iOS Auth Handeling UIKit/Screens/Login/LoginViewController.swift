// Created by Anton Kukhlevskyi on 2025-01-03.
// Copyright © 2025 Airbnb Inc. All rights reserved.

import UIKit

class LoginViewController : UIViewController {
  private lazy var emailTextFiled: UITextField = .makeEmailField("Email", delegate: self)
  private lazy var passwordTextFiled: UITextField = .makePasswordField("Password", delegate: self)
  private lazy var submitButton: UIButton = .makeButton("Submit", configuration: UIButton.Configuration.filled()).registerAction(self.onSubmitTapped)
  private lazy var registerButton: UIButton = .makeButton("Register").registerAction(self.onRegisterTapped)
  
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
extension LoginViewController {
  override func viewDidLoad() {
    super.viewDidLoad()

    setupViews()
  }
}

// MARK: - View Setup/Configuration
private extension LoginViewController {
  func setupViews() {
    title = "Login"
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
    
    submitButton
      .addTo(view)
      .centerXOn(view)
      .pinTop(toAnchor: passwordTextFiled.bottomAnchor, constant: 12)
    
    registerButton
      .addTo(view)
      .pinTop(toAnchor: view.safeAreaLayoutGuide.topAnchor)
      .pinTrailing(toAnchor: view.safeAreaLayoutGuide.trailingAnchor, constant: -12)
  }
}

// MARK: - Actions
extension LoginViewController {
  @objc func onSubmitTapped() {
    viewModel?.email = emailTextFiled.text
    viewModel?.password = passwordTextFiled.text
    viewModel?.onAction(.submit(self.onLoginHandler))
  }

  @objc func onRegisterTapped() {
    viewModel?.onAction(.toRegister)
  }

  private func onLoginHandler(result: Result<AccessToken, Error>) {
    switch result {
    case .success(_): viewModel?.onAction(.toHome)
    case .failure(_: let error): showOkAlert(title: "Error", message: error.localizedDescription)
    }
  }
}

// MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if textField == emailTextFiled {
      passwordTextFiled.becomeFirstResponder()
    } else {
      view.endEditing(true)
    }
    return false
  }
}

#Preview {
  LoginViewController(viewModel: nil)
}
