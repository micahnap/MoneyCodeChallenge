import UIKit

class TransactionDetailViewController: UIViewController {

	@IBOutlet weak var txnIdLabel: UILabel!
	@IBOutlet weak var createdLabel: UILabel!
	@IBOutlet weak var descriptionLabel: UILabel!
	@IBOutlet weak var amountLabel: UILabel!
	@IBOutlet weak var currencyLabel: UILabel!
	@IBOutlet weak var pendingLabel: UILabel!


	@IBOutlet weak var merchantNameLabel: UILabel!
	@IBOutlet weak var addressLabel: UILabel!
	@IBOutlet weak var cityLabel: UILabel!
	@IBOutlet weak var regionLabel: UILabel!
	@IBOutlet weak var countryLabel: UILabel!
	@IBOutlet weak var postcodeLabel: UILabel!
	@IBOutlet weak var latitudeLabel: UILabel!
	@IBOutlet weak var longitudeLabel: UILabel!

	private let transaction: Transaction

	init(transaction: Transaction) {
		self.transaction = transaction
		super.init(nibName: "TransactionDetailViewController", bundle: Bundle.main)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		configureLabels()
	}

	private func configureLabels() {
		txnIdLabel.text = "ID: \(transaction.id)"
		createdLabel.text = "Created: \(transaction.created)"
		descriptionLabel.text = "Description: \(transaction.description)"
		amountLabel.text = "Amount: \(transaction.amount)"
		currencyLabel.text = "Currency: \(transaction.currency)"
		pendingLabel.text = "Pending: \(transaction.amount_is_pending)"

		merchantNameLabel.text = "Merchant name: \(transaction.merchant.name)"
		addressLabel.text = "Address: \(transaction.merchant.address?.address ?? "")"
		cityLabel.text = "City: \(transaction.merchant.address?.city ?? "")"
		regionLabel.text = "Region: \(transaction.merchant.address?.region ?? "")"
		countryLabel.text = "Country: \(transaction.merchant.address?.country ?? "")"
		postcodeLabel.text = "Postcode: \(transaction.merchant.address?.postcode ?? "")"
		latitudeLabel.text = "Latitude: \(transaction.merchant.address?.latitude ?? 0)"
		longitudeLabel.text = "Longitude: \(transaction.merchant.address?.longitude ?? 0)"
	}
}
