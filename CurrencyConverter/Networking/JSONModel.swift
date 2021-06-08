//
//  JSONModel.swift
//  CurrencyConverter
//
//  Created by Владислав Банков.
//

import Foundation

struct JSONModel: Codable {
	var date, previousDate: String
	var previousURL: String
	var timestamp: String
	var valute: [String: Valute]

	enum CodingKeys: String, CodingKey {
		case date = "Date"
		case previousDate = "PreviousDate"
		case previousURL = "PreviousURL"
		case timestamp = "Timestamp"
		case valute = "Valute"
	}
}

struct Valute: Codable {
	var id, charCode, numCode: String
	var nominal: Int
	var name: String
	var value, previous: Float

	enum CodingKeys: String, CodingKey {
		case id = "ID"
		case numCode = "NumCode"
		case charCode = "CharCode"
		case nominal = "Nominal"
		case name = "Name"
		case value = "Value"
		case previous = "Previous"
	}
}
