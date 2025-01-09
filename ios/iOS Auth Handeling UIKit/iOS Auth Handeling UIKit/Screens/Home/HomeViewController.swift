// Created by Anton Kukhlevskyi on 2025-01-04.
// Copyright © 2025 Airbnb Inc. All rights reserved.

import Combine
import UIKit

class HomeViewController : UIViewController {
  private lazy var infoTextView: UITextView = .makeTextView("Tap fetch button to fetch secured data")
  private lazy var fetchButton: UIButton = .makeButton("Fetch Data").registerAction(self.onFetchTapped)
  private lazy var resetButton: UIButton = .makeButton("Reset Data").registerAction(self.onResetTapped)
  private lazy var logoutButton: UIButton = .makeButton("Log out").registerAction(self.onLogoutTapped)


  private var cancellables = Set<AnyCancellable>()
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
extension HomeViewController {
  override func viewDidLoad() {
    super.viewDidLoad()

    setupViews()
    setupObservers()
  }

  override func viewWillDisappear(_ animated: Bool) {
    cancellables = []
    super.viewWillDisappear(animated)
  }
}

// MARK: - View Setup/Configuration
private extension HomeViewController {
  func setupViews() {
    title = "Home"
    view.backgroundColor = .white

    infoTextView
      .addTo(view)
      .centerOn(view)
      .setDefaultFiledSize(superview: view)

    fetchButton
      .addTo(view)
      .centerXOn(view)
      .pinTop(toAnchor: infoTextView.bottomAnchor, constant: 12)
      .setDefaultFiledSize(superview: view)

    resetButton
      .addTo(view)
      .centerXOn(view)
      .pinTop(toAnchor: fetchButton.bottomAnchor, constant: 12)
      .setDefaultFiledSize(superview: view)

    logoutButton
      .addTo(view)
      .pinTop(toAnchor: view.safeAreaLayoutGuide.topAnchor)
      .pinTrailing(toAnchor: view.safeAreaLayoutGuide.trailingAnchor, constant: -12)
  }
}

// MARK: - Observers
private extension HomeViewController {
  func setupObservers() {
    viewModel?.$infoText
      .receive(on: DispatchQueue.main)
      .sink { [weak self] newText in
        self?.infoTextView.text = newText

      }.store(in: &cancellables)
  }
}

// MARK: - Actions
extension HomeViewController {
  func onFetchTapped() { viewModel?.onAction(.fetchData(self.onFetchResult)) }
  func onResetTapped() { viewModel?.onAction(.restoreData) }
  func onLogoutTapped() { viewModel?.onAction(.logout) }

  private func onFetchResult(result: Result<SecureFetchData, Error>) {
    switch result {
    case .success(_): ()
    case .failure(_: let error): showOkAlert(title: "Error", message: error.localizedDescription)
    }
  }
}


#Preview {
  HomeViewController(viewModel: nil)
}
