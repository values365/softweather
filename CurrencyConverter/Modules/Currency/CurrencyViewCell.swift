//
//  CurrencyViewCell.swift
//  CurrencyConverter
//
//  Created by Владислав Банков.
//

import UIKit

final class CurrencyViewCell: UITableViewCell {

	// MARK: - Properties

	static let identifier = "currency-cell"

	// MARK: - UI Components

	private let titleLabel = UILabel()
	private let subTitleLabel = UILabel()
	private let checkBoxLabel = UILabel()

	// MARK: - Init

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)

		setupAppearance()
		setupLayout()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func awakeFromNib() {
		super.awakeFromNib()
	}

	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
		if selected {
			self.setSelected(false, animated: false)
		}
	}

	override func prepareForReuse() {
		super.prepareForReuse()
	}

	// MARK: - Public Methods

	func setTitle(_ title: String) {
		titleLabel.text = title
	}

	func setSubTitle(_ title: String) {
		subTitleLabel.text = title
	}

	func showIcon() {
		checkBoxLabel.isHidden = false
	}

	func hideIcon() {
		checkBoxLabel.isHidden = true
	}
}

// MARK: - Appearance & Layout

private extension CurrencyViewCell {
	func setupAppearance() {
		contentView.backgroundColor = .systemGray5
		titleLabel.numberOfLines = 0
		titleLabel.textAlignment = .left
		titleLabel.font = .boldSystemFont(ofSize: Constants.regularFontSize.rawValue)

		subTitleLabel.font = .boldSystemFont(ofSize: Constants.regularFontSize.rawValue)
		subTitleLabel.textAlignment = .center
		subTitleLabel.textColor = .systemGray2

		checkBoxLabel.font = .boldSystemFont(ofSize: Constants.regularFontSize.rawValue)
		checkBoxLabel.textAlignment = .center
		checkBoxLabel.text = StringConstants.checkBoxEmoji.rawValue
	}

	func setupLayout() {
		addSubview(titleLabel)
		addSubview(subTitleLabel)
		addSubview(checkBoxLabel)
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		subTitleLabel.translatesAutoresizingMaskIntoConstraints = false
		checkBoxLabel.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.defaultSpacing.rawValue),
			titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
			titleLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: Constants.titleLabelWidthMultiplier.rawValue),

			subTitleLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
			subTitleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
			subTitleLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: Constants.subTitleLabelWidthMultiplier.rawValue),

			checkBoxLabel.leadingAnchor.constraint(equalTo: subTitleLabel.trailingAnchor),
			checkBoxLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
			checkBoxLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -Constants.defaultSpacing.rawValue)
		])
	}
}

