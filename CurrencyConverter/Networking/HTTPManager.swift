//
//  HTTPManager.swift
//  CurrencyConverter
//
//  Created by Владислав Банков.
//

import Foundation

final class HTTPManager {
	func makeGetRequest(to url: URL, completion: @escaping (_ data: Data?, _ error: Error?) -> Void) {
		DispatchQueue.global(qos: .userInteractive).async {
			var request = URLRequest(url: url)
			request.httpMethod = "get"
			let session = URLSession(configuration: URLSessionConfiguration.default)
			let task = session.dataTask(with: request) { data, response, error in completion(data, error) }
			task.resume()
		}
	}
}
