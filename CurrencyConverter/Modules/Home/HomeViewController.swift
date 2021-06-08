//
//  HomeViewController.swift
//  CurrencyConverter
//
//  Created by Владислав Банков.
//

import UIKit

protocol IHomeViewController: UIViewController {
	var tapButtonHandler: ((_ side: CurrencySide) -> Void)? { get set }

	func throwUserInput(input: String, with side: CurrencySide)
	func setFields(leftHandSideFieldValue: String?, rightHandSideFieldValue: String?)
	func setLabels(leftHandSideLabelValue: String?, rightHandSideLabelValue: String?)
	func getFields() -> (String, String)
	func getLabels() -> (String, String)
	func dismissSpinner()
}

final class HomeViewController: UIViewController {

	var tapButtonHandler: ((_ side: CurrencySide) -> Void)?
	
	private let presenter: IHomePresenter
	private let homeView = HomeView()
	
	init(with presenter: IHomePresenter) {
		self.presenter = presenter
		super.init(nibName: nil, bundle: nil)
		title = StringConstants.currencyConverterTitle.rawValue
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func loadView() {
		view = homeView
		homeView.delegate = self
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		presenter.viewDidLoad(with: self)
	}
}

extension HomeViewController: IHomeViewController {
	func throwUserInput(input: String, with side: CurrencySide) {
		presenter.valueDidEntered(value: input, from: side)
	}

	func getLabels() -> (String, String) {
		let labels = homeView.getLabels()
		// this condition gonna be ok always
		guard let label1 = labels.0, let label2 = labels.1 else { return ("", "") }
		return (label1, label2)
	}


	func getFields() -> (String, String) {
		let fields = homeView.getFields()
		// we always have character in the text field even if it's empty, so below condition gonna be ok always
		guard let field1 = fields.0, let field2 = fields.1 else { return ("", "") }
		return (field1, field2)
	}
	
	func setFields(leftHandSideFieldValue: String?, rightHandSideFieldValue: String?) {
		homeView.setFields(leftHandSideFieldValue: leftHandSideFieldValue, rightHandSideFieldValue: rightHandSideFieldValue)
	}

	func setLabels(leftHandSideLabelValue: String?, rightHandSideLabelValue: String?) {
		homeView.setLabels(leftHandSideLabelValue: leftHandSideLabelValue, rightHandSideLabelValue: rightHandSideLabelValue)
	}

	func dismissSpinner() {
		homeView.dismissSpinner()
	}
}

enum CurrencySide { case right, left }
