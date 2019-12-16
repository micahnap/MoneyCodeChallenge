import UIKit

protocol TransactionViewControllerCoordinatorDelegate: AnyObject {
	func transactionViewController(_ viewController: TransactionViewController, didSelect transaction: Transaction)
}

class TransactionViewController: UIViewController {
	static let CellIdentifier = "TransactionCell"

	@IBOutlet weak var tableView: UITableView!
	typealias Service = TransactionFetchable

	init(service: Service) {
		self.service = service
		super.init(nibName: "TransactionViewController", bundle: Bundle.main)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private let service: Service
	private var transactions: [Transaction]?
	weak var coordinator: TransactionViewControllerCoordinatorDelegate?

	private var _transactionsGroupedByDate: [Date : [Transaction]]?
	private var transactionsGroupedByDate: [Date : [Transaction]]? {
		guard let transactionsGroupedByDate = _transactionsGroupedByDate else {
			guard let transactions = transactions else {
				return nil
			}

			let dictionary = [Date : [Transaction]]()
			let groupedByDate = transactions.reduce(into: dictionary) { acc, cur in
				let components = Calendar.current.dateComponents([.year, .month, .day], from: cur.created)
				let date = Calendar.current.date(from: components)!
				let existing = acc[date] ?? []
				acc[date] = existing + [cur]
			}
			_transactionsGroupedByDate = groupedByDate
			return groupedByDate
		}
		return transactionsGroupedByDate
	}

	private lazy var formatter: ISO8601DateFormatter = {
		let formatter = ISO8601DateFormatter()
		formatter.formatOptions = [
			.withYear,
			.withMonth,
			.withDay,
		]
		return formatter
	}()

	private var _sortedTransactionDates: [Date]?
	private var sortedTransactionDates: [Date]? {
		guard let sortedTransactionDates = _sortedTransactionDates else {
			guard let transactionDates = transactionsGroupedByDate?.keys else {
				return nil
			}
			let sortedDates = transactionDates.sorted(by: { $0 < $1 })
			_sortedTransactionDates = sortedDates
			return sortedDates
		}
		return sortedTransactionDates
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		tableView.register(UINib(nibName: "TransactionCell", bundle: Bundle.main), forCellReuseIdentifier: TransactionViewController.CellIdentifier)
		tableView.tableFooterView = UIView()
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		loadData()
	}

	private func loadData() {
		service.getTransactions { (result) in
			switch result {
			case .success(let transactions):
				self.transactions = transactions.sorted(by: { $0.created < $1.created } )
				self.tableView.reloadData()
			case .failure(let error):
				assertionFailure(error.localizedDescription)
			}
		}
	}
}

extension TransactionViewController: UITableViewDelegate, UITableViewDataSource {

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		guard let createdDate = sortedTransactionDates?[section],
		let transactionsByDate = transactionsGroupedByDate?[createdDate] else {
			return 0
		}
		return transactionsByDate.count
	}

	func numberOfSections(in tableView: UITableView) -> Int {
		return sortedTransactionDates?.count ?? 0
	}

	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		guard let createdDate = sortedTransactionDates?[section] else {
			return nil
		}
		return formatter.string(from: createdDate)
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: TransactionViewController.CellIdentifier, for: indexPath) as? TransactionCell,
			let date = sortedTransactionDates?[indexPath.section],
			let transactionsByDate = transactionsGroupedByDate?[date] else {
			return UITableViewCell()
		}
		let transaction = transactionsByDate[indexPath.row]
		cell.amountLabel.text = String(transaction.amount)
		cell.descriptionLabel.text = transaction.description
		cell.merchantLabel.text = transaction.merchant.name
		cell.pendingLabel.text = transaction.amount_is_pending ? "Pending" : "Settled"
		return cell
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		guard let createdDate = sortedTransactionDates?[indexPath.section],
		let transactionsByDate = transactionsGroupedByDate?[createdDate] else {
			return
		}
		let transaction = transactionsByDate[indexPath.row]
		coordinator?.transactionViewController(self, didSelect: transaction)
	}
}
