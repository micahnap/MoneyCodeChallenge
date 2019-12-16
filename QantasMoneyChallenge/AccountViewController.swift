import UIKit

protocol AccountViewControllerCoordinatorDelegate: AnyObject {
	func accountViewControllerDidSelectAccount(_ viewController: AccountViewController)
}

class AccountViewController: UIViewController {

	static let CellIdentifier = "AccountCell"

	@IBOutlet weak var tableView: UITableView!
	typealias Service = AccountFetchable

	init(service: Service) {
		self.service = service
		super.init(nibName: "AccountViewController", bundle: Bundle.main)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private let service: Service
	private var accounts: [Account]?
	weak var coordinator: AccountViewControllerCoordinatorDelegate?

	override func viewDidLoad() {
		super.viewDidLoad()
		tableView.register(UINib(nibName: "AccountCell", bundle: Bundle.main), forCellReuseIdentifier: AccountViewController.CellIdentifier)
		tableView.tableFooterView = UIView()
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		loadData()
	}

	private func loadData() {
		service.getAccounts { [weak self] (result) in
			switch result {
			case .success(let accounts):
				self?.accounts = accounts
				self?.tableView.reloadData()
			case .failure(let error):
				self?.presentAlert(title: "Error", message: error.localizedDescription)
			}
		}
	}

	private func presentAlert(title: String, message: String) {
		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
		self.present(alert, animated: true, completion: nil)
	}
}

extension AccountViewController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return accounts?.count ?? 0
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: AccountViewController.CellIdentifier, for: indexPath) as? AccountCell,
			let accounts = accounts else {
			return UITableViewCell()
		}

		let account = accounts[indexPath.row]

		cell.nameLabel.text = account.name
		cell.balanceLabel.text = String(account.balance)
		cell.availableBalanceLabel.text = String(account.available_balance)
		return cell
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		coordinator?.accountViewControllerDidSelectAccount(self)
	}
}
