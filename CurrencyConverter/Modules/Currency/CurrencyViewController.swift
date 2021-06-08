//
//  CurrencyViewController.swift
//  CurrencyConverter
//
//  Created by Владислав Банков.
//

import UIKit

protocol ICurrencyViewController: AnyObject {}

final class CurrencyViewController: UIViewController {
	
	// MARK: - Properties

	private let presenter: ICurrencyPresenter
	private let tableView = UITableView()

	private var selectedCurrency = ""
	private var selectedPath = IndexPath()
	
	// MARK: - Init
	
	init(with presenter: ICurrencyPresenter) {
		self.presenter = presenter
		super.init(nibName: nil, bundle: nil)
		prepareView()
		setupTableViewLayout()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Life Cycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		presenter.viewDidLoad(with: self)
		selectedCurrency = presenter.currentValute
	}
}

// MARK: - Internal Methods

private extension CurrencyViewController {
	func prepareView() {
		title = StringConstants.changeCurrencyTitle.rawValue
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: StringConstants.cancelButtonText.rawValue,
															style: .done, target: self, action: #selector(dismissView))
		navigationController?.navigationBar.backgroundColor = .systemGray5
		tableView.register(CurrencyViewCell.self, forCellReuseIdentifier: CurrencyViewCell.identifier)
		tableView.dataSource = self
		tableView.delegate = self
	}
	
	func setupTableViewLayout() {
		view.addSubview(tableView)
		tableView.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
			tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
			tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
		])
	}
	
	@objc func dismissView() {
		dismiss(animated: true) { [weak self] in
			guard let self = self else { return assertionFailure("CurrencyViewController self link is nil") }
			guard let currency = self.presenter.selectedValute else { return }
			self.presenter.currencyDidSelected(currency: currency)
		}
	}
}

// MARK: - Table View Data Source

extension CurrencyViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return presenter.currencies.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: CurrencyViewCell.identifier, for: indexPath) as! CurrencyViewCell
		if Array(presenter.currencies.keys)[indexPath.row] != selectedCurrency { cell.hideIcon() } else {
			cell.showIcon()
			selectedPath = indexPath
		}
		cell.setTitle(Array(presenter.currencies.values)[indexPath.row].name)
		cell.setSubTitle(Array(presenter.currencies.keys)[indexPath.row])
		return cell
	}
}

// MARK: - Table View Delegate

extension CurrencyViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return Constants.cellHeight.rawValue
	}

	func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
		if let cell = tableView.cellForRow(at: indexPath) as? CurrencyViewCell { cell.hideIcon() }
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if let cell = tableView.cellForRow(at: indexPath) as? CurrencyViewCell { cell.showIcon() }
		if let cell = tableView.cellForRow(at: selectedPath) as? CurrencyViewCell { cell.hideIcon() }
		selectedCurrency = Array(presenter.currencies.keys)[indexPath.row]
		presenter.rowDidSelected(with: indexPath.row)
	}
}


// MARK: - ICurrencyViewController

extension CurrencyViewController: ICurrencyViewController {}
