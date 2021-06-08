//
//  HomePresenter.swift
//  CurrencyConverter
//
//  Created by Владислав Банков.
//

import UIKit

protocol IHomePresenter {
	func viewDidLoad(with viewController: IHomeViewController)
	func valuteDidChange(newValute: Valute)
	func valueDidEntered(value: String, from side: CurrencySide)
	func allCurrencies() -> [String: Valute]?
}

final class HomePresenter {
	
	private weak var viewController: IHomeViewController?
	private var side: CurrencySide = .left
	private var jsonModel: JSONModel?
	private var convertHelper: ConvertHelper?
	private var url: URL? { URL(string: "https://www.cbr-xml-daily.ru/daily_json.js") }
	private let httpManager = HTTPManager()
}

extension HomePresenter: IHomePresenter {
	func valueDidEntered(value: String, from side: CurrencySide) {
		guard let convertHelper = convertHelper else { return }
		guard let floatValue = Float(value.replacingOccurrences(of: ",", with: ".")) else { return }
		guard let labels = viewController?.getLabels() else { return }
		let result = convertHelper.calculate(value: floatValue, keys: (labels.0, labels.1), whereSideIs: side)
		let stringResult = String(format: "%.2f", result)
		side == .left ? viewController?.setFields(leftHandSideFieldValue: nil, rightHandSideFieldValue: stringResult)
			: viewController?.setFields(leftHandSideFieldValue: stringResult, rightHandSideFieldValue: nil)
	}

	func allCurrencies() -> [String : Valute]? { jsonModel?.valute }

	func valuteDidChange(newValute: Valute) {
		guard let viewController = viewController else { return assertionFailure("IHomeViewController weak link is nil") }
		side == .left ? viewController.setLabels(leftHandSideLabelValue: newValute.charCode, rightHandSideLabelValue: nil)
			: viewController.setLabels(leftHandSideLabelValue: nil, rightHandSideLabelValue: newValute.charCode)
		viewController.setFields(leftHandSideFieldValue: "", rightHandSideFieldValue: "")
	}

	func viewDidLoad(with viewController: IHomeViewController) {
		self.viewController = viewController
		loadData()
		viewController.tapButtonHandler = { [weak self] side in
			guard let self = self else { return assertionFailure("IHomeViewPresenter self link is nil") }
			self.side = side
			let currentValutes = viewController.getLabels()
			var currency = ""
			if side == .left { currency = currentValutes.0 } else { currency = currentValutes.1 }
			let currencyPresenter = CurrencyPresenter(with: self, currentValute: currency)
			let currencyViewController = Assembly.initCurrencyModule(with: currencyPresenter)
			let navigationController = UINavigationController(rootViewController: currencyViewController)
			viewController.present(navigationController, animated: true)
		}
	}
}

private extension HomePresenter {
	func loadData() {
		guard let url = url else { return assertionFailure() }
		httpManager.makeGetRequest(to: url) { [weak self] data, error in
			guard let self = self else { return assertionFailure("HomePresenter self link is nil") }
			guard let data = data else { return assertionFailure("couldn't get request data from the server") }
			let decoder = JSONDecoder()
			guard var model = try? decoder.decode(JSONModel.self, from: data) else { return assertionFailure("cannot cast json data into JSONModel struct") }
			model.valute["RUB"] = Valute(id: "R00000", charCode: "RUB", numCode: "000", nominal: 1, name: "Российский рубль", value: 1, previous: 1)
			self.viewController?.dismissSpinner()
			self.jsonModel = model
			self.initHelper()
		}
	}

	func initHelper() {
		guard let model = jsonModel else { return assertionFailure("jsonModel is nil") }
		convertHelper = ConvertHelper(model: model)
		viewController?.setLabels(leftHandSideLabelValue: "RUB", rightHandSideLabelValue: "USD")
	}
}
