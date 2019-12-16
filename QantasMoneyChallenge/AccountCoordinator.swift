import Foundation
import UIKit

class AccountCoordinator {

	typealias Service = AccountFetchable & TransactionFetchable

	init() {
		self.service = AccountService(client: AccountClient())
	}

	private weak var _accountViewController: AccountViewController?
	private let service: Service

    var accountViewController: AccountViewController {
        if let accountViewController = _accountViewController {
            return accountViewController
        }

        let accountViewController = AccountViewController(service: service)
		accountViewController.coordinator = self
        _accountViewController = accountViewController
        return accountViewController
    }

    private weak var _navigationController: UINavigationController?

	var navigationController: UINavigationController {
        if let navigationController = _navigationController {
            return navigationController
        }

        let navigationController = UINavigationController()
        _navigationController = navigationController
        navigationController.setViewControllers([accountViewController], animated: false)
        return navigationController
    }
}

extension AccountCoordinator: AccountViewControllerCoordinatorDelegate {
	func accountViewControllerDidSelectAccount(_ viewController: AccountViewController) {
		let service = self.service
		let txnViewController = TransactionViewController(service: service)
		txnViewController.coordinator = self
		navigationController.pushViewController(txnViewController, animated: true)
	}
}

extension AccountCoordinator: TransactionViewControllerCoordinatorDelegate {
	func transactionViewController(_ viewController: TransactionViewController, didSelect transaction: Transaction) {
		let txnDetailVC = TransactionDetailViewController(transaction: transaction)
		navigationController.pushViewController(txnDetailVC, animated: true)
	}
}
