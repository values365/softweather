//
//  CurrencyPresenter.swift
//  CurrencyConverter
//
//  Created by Владислав Банков.
//

import Foundation

protocol ICurrencyPresenter {
	var currencies: [String: Valute] { get }
	var selectedValute: Valute? { get }
	var currentValute: String { get }
	func viewDidLoad(with viewController: ICurrencyViewController)
	func rowDidSelected(with index: Int)
	func currencyDidSelected(currency: Valute)
}

final class CurrencyPresenter {

	var delegate: IHomePresenter
	var currencies: [String: Valute]
	var selectedValute: Valute?
	var currentValute: String

	private weak var viewController: ICurrencyViewController?
	private var previousModulePresenter: IHomePresenter?

	init(with delegate: IHomePresenter, currentValute: String) {
		self.delegate = delegate
		self.currentValute = currentValute
		// using force-unwrap because ihomepresenter obj got all currencies at this step (it can't be not)
		self.currencies = delegate.allCurrencies()!
	}
}

extension CurrencyPresenter: ICurrencyPresenter {
	func rowDidSelected(with index: Int) {
		selectedValute = Array(currencies.values)[index]
	}

	func viewDidLoad(with viewController: ICurrencyViewController) {
		self.viewController = viewController
	}

	func currencyDidSelected(currency: Valute) {
		delegate.valuteDidChange(newValute: currency)
	}
}
