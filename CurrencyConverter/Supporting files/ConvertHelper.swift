//
//  ConvertHelper.swift
//  CurrencyConverter
//
//  Created by Владислав Банков.
//

import Foundation

final class ConvertHelper {

	private var model: JSONModel

	init(model: JSONModel) {
		self.model = model
	}

	func calculate(value: Float, keys: (String, String), whereSideIs side: CurrencySide) -> Float {
		let cost1: Float = getActualCurrency(forKey: keys.0)
		let cost2: Float = getActualCurrency(forKey: keys.1)
		return side == .left ? value * cost1 / cost2 : value * cost2 / cost1
	}

	func getActualCurrency(forKey key: String) -> String? {
		guard let currency = model.valute[key] else { return nil }
		let floatValue = currency.value / Float(currency.nominal)
		return String(format: "%.2f", floatValue)
	}

	func getActualCurrency(forKey key: String) -> Float {
		guard let currency = model.valute[key] else { return 0 }
		return currency.value / Float(currency.nominal)
	}

}
