//
//  HomeView.swift
//  CurrencyConverter
//
//  Created by Владислав Банков.
//

import UIKit

final class HomeView: UIView {

	// MARK: - Properties

	var delegate: IHomeViewController?
	
	// MARK: - UI Components

	private let spinner = UIActivityIndicatorView(style: .large)
	
	private let leftHandValueTextField = UITextField()
	private let rightHandValueTextField = UITextField()
	private let arrowView = UIImageView()
	private let leftHandCurrencyLabel = UILabel()
	private let rightHandCurrencyLabel = UILabel()
	private let leftHandCurrencyButton = UIButton()
	private let rightHandCurrencyButton = UIButton()

	// MARK: - Constraints

	private var fieldsConstraints: [NSLayoutConstraint] = []
	private var labelsConstraints: [NSLayoutConstraint] = []
	private var buttonsConstraints: [NSLayoutConstraint] = []
	
	// MARK: - Init
	
	init() {
		super.init(frame: .zero)
		
		let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
		addGestureRecognizer(tap)
		NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
		leftHandCurrencyButton.addTarget(self, action: #selector(leftButtonDidTapped), for: .touchUpInside)
		rightHandCurrencyButton.addTarget(self, action: #selector(rightButtonDidTapped), for: .touchUpInside)
		setupConstraints()
		setupAppearance()
		setupLayout()
		spinner.startAnimating()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Public Methods

	func setFields(leftHandSideFieldValue: String?, rightHandSideFieldValue: String?) {
		DispatchQueue.main.async { [weak self] in
			guard let self = self else { return assertionFailure("HomeView self link is nil ") }
			if let value = leftHandSideFieldValue { self.leftHandValueTextField.text = value }
			if let value = rightHandSideFieldValue { self.rightHandValueTextField.text = value }
		}
	}

	func setLabels(leftHandSideLabelValue: String?, rightHandSideLabelValue: String?) {
		DispatchQueue.main.async { [weak self] in
			guard let self = self else { return assertionFailure("HomeView self link is nil ") }
			if let value = leftHandSideLabelValue { self.leftHandCurrencyLabel.text = value }
			if let value = rightHandSideLabelValue { self.rightHandCurrencyLabel.text = value }
		}
	}

	func getFields() -> (String?, String?) { return (leftHandValueTextField.text, rightHandValueTextField.text) }

	func getLabels() -> (String?, String?) { return (leftHandCurrencyLabel.text, rightHandCurrencyLabel.text) }

	func dismissSpinner() {
		DispatchQueue.main.async { [weak self] in
			guard let self = self else { return assertionFailure("HomeView self link is nil ") }
			self.spinner.isHidden = true
			self.arrowView.isHidden = false
			NSLayoutConstraint.activate(self.fieldsConstraints + self.labelsConstraints + self.buttonsConstraints)
		}
	}
}

// MARK: - Internal Methods

private extension HomeView {
	func setupConstraints() {
		fieldsConstraints.append(contentsOf: [
			leftHandValueTextField.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: Constants.defaultSpacing.rawValue),
			leftHandValueTextField.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: Constants.regularSpacing.rawValue + Constants.appleSpacing.rawValue),
			leftHandValueTextField.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: Constants.fieldsWidthMultiplier.rawValue),
			rightHandValueTextField.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: Constants.defaultSpacing.rawValue),
			rightHandValueTextField.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -Constants.regularSpacing.rawValue - Constants.appleSpacing.rawValue),
			rightHandValueTextField.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: Constants.fieldsWidthMultiplier.rawValue)
		])

		labelsConstraints.append(contentsOf: [
			leftHandCurrencyLabel.topAnchor.constraint(equalTo: arrowView.bottomAnchor, constant: Constants.appleSpacing.rawValue / 2),
			leftHandCurrencyLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: Constants.regularSpacing.rawValue),
			leftHandCurrencyLabel.widthAnchor.constraint(equalToConstant: Constants.labelsWidth.rawValue),
			rightHandCurrencyLabel.topAnchor.constraint(equalTo: arrowView.bottomAnchor, constant: Constants.appleSpacing.rawValue / 2),
			rightHandCurrencyLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -Constants.regularSpacing.rawValue),
			rightHandCurrencyLabel.widthAnchor.constraint(equalToConstant: Constants.labelsWidth.rawValue)
		])

		buttonsConstraints.append(contentsOf: [
			leftHandCurrencyButton.topAnchor.constraint(equalTo: leftHandCurrencyLabel.bottomAnchor, constant: Constants.regularSpacing.rawValue),
			leftHandCurrencyButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: Constants.defaultSpacing.rawValue * 1.5),
			leftHandCurrencyButton.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: Constants.widthMultiplier.rawValue),
			rightHandCurrencyButton.topAnchor.constraint(equalTo: leftHandCurrencyLabel.bottomAnchor, constant: Constants.regularSpacing.rawValue),
			rightHandCurrencyButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -Constants.defaultSpacing.rawValue * 1.5),
			rightHandCurrencyButton.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: Constants.widthMultiplier.rawValue)
		])
	}

	func getInput() {
		guard let leftHandSideInput = leftHandValueTextField.text else { return }
		guard let rightHandSideInput = rightHandValueTextField.text else { return }
		guard leftHandSideInput == "" || rightHandSideInput == "" else {
			leftHandValueTextField.text = ""
			rightHandValueTextField.text = ""
			return
		}
		guard let delegate = delegate else { return }
		if leftHandSideInput == "" {
			delegate.throwUserInput(input: rightHandSideInput, with: .right)
		} else {
			delegate.throwUserInput(input: leftHandSideInput, with: .left)
		}
	}

	@objc func keyboardWillShow() {
		leftHandValueTextField.text = ""
		rightHandValueTextField.text = ""
	}

	@objc func leftButtonDidTapped() {
		delegate?.tapButtonHandler?(.left)
	}

	@objc func rightButtonDidTapped() {
		delegate?.tapButtonHandler?(.right)
	}

	@objc func dismissKeyboard() {
		endEditing(true)
		getInput()
	}
}

// MARK: - Appearance

private extension HomeView {
	func setupAppearance() {
		backgroundColor = .systemBackground
		setupFieldsAppearance()
		setupLabelsAppearance()
		setupButtonsAppearance()
	}
	
	func setupFieldsAppearance() {
		leftHandValueTextField.placeholder = "0"
		leftHandValueTextField.font = .boldSystemFont(ofSize: Constants.commonFontSize.rawValue)
		leftHandValueTextField.textAlignment = .left
		leftHandValueTextField.keyboardType = .decimalPad
		
		rightHandValueTextField.placeholder = "0"
		rightHandValueTextField.font = .boldSystemFont(ofSize: Constants.commonFontSize.rawValue)
		rightHandValueTextField.textAlignment = .right
		rightHandValueTextField.keyboardType = .decimalPad
	}
	
	func setupLabelsAppearance() {
		arrowView.image = UIImage(named: "grayArrow")
		arrowView.isHidden = true
		
		leftHandCurrencyLabel.font = .boldSystemFont(ofSize: Constants.commonFontSize.rawValue)
		leftHandCurrencyLabel.textAlignment = .center

		rightHandCurrencyLabel.font = .boldSystemFont(ofSize: Constants.commonFontSize.rawValue)
		rightHandCurrencyLabel.textAlignment = .center
	}
	
	func setupButtonsAppearance() {
		leftHandCurrencyButton.setTitle(StringConstants.buttonText.rawValue, for: UIControl.State.normal)
		leftHandCurrencyButton.titleLabel?.font = .systemFont(ofSize: Constants.regularFontSize.rawValue)
		leftHandCurrencyButton.setTitleColor(.systemTeal, for: UIControl.State.normal)
		leftHandCurrencyButton.titleLabel?.textAlignment = .center
		leftHandCurrencyButton.titleLabel?.numberOfLines = 2
		
		rightHandCurrencyButton.setTitle(StringConstants.buttonText.rawValue, for: UIControl.State.normal)
		rightHandCurrencyButton.titleLabel?.font = .systemFont(ofSize: Constants.regularFontSize.rawValue)
		rightHandCurrencyButton.setTitleColor(.systemTeal, for: UIControl.State.normal)
		rightHandCurrencyButton.titleLabel?.textAlignment = .center
		rightHandCurrencyButton.titleLabel?.numberOfLines = 2
	}
}

// MARK: - Layout

private extension HomeView {
	func setupLayout() {
		setupSpinnerLayout()
		setupFieldsLayout()
		setupLabelsLayout()
		setupButtonsLayout()
	}

	func setupSpinnerLayout() {
		addSubview(spinner)
		spinner.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
			spinner.centerYAnchor.constraint(equalTo: centerYAnchor)
		])
	}
	
	func setupFieldsLayout() {
		addSubview(leftHandValueTextField)
		addSubview(rightHandValueTextField)
		leftHandValueTextField.translatesAutoresizingMaskIntoConstraints = false
		rightHandValueTextField.translatesAutoresizingMaskIntoConstraints = false
	}
	
	func setupLabelsLayout() {
		addSubview(arrowView)
		addSubview(leftHandCurrencyLabel)
		addSubview(rightHandCurrencyLabel)
		arrowView.translatesAutoresizingMaskIntoConstraints = false
		leftHandCurrencyLabel.translatesAutoresizingMaskIntoConstraints = false
		rightHandCurrencyLabel.translatesAutoresizingMaskIntoConstraints = false

		NSLayoutConstraint.activate([
			arrowView.topAnchor.constraint(equalTo: rightHandValueTextField.bottomAnchor, constant: Constants.appleSpacing.rawValue / 2),
			arrowView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
			arrowView.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: Constants.widthMultiplier.rawValue),
			arrowView.heightAnchor.constraint(equalTo: arrowView.widthAnchor, multiplier: Constants.arrowViewHeightMultiplier.rawValue)
		])
	}
	
	func setupButtonsLayout() {
		addSubview(leftHandCurrencyButton)
		addSubview(rightHandCurrencyButton)
		leftHandCurrencyButton.translatesAutoresizingMaskIntoConstraints = false
		rightHandCurrencyButton.translatesAutoresizingMaskIntoConstraints = false
	}
}


