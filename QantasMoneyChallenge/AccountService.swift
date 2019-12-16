import Foundation

protocol AccountFetchable {
	func getAccounts(completion: @escaping (Result<[Account], Error>) -> Void)
}

protocol TransactionFetchable {
	func getTransactions(completion: @escaping (Result<[Transaction], Error>) -> Void)
}

struct AccountService {
	init(client: AccountClient) {
		self.client = client
	}

	private let client: AccountClient
}

extension AccountService: AccountFetchable, TransactionFetchable {
	func getTransactions(completion: @escaping (Result<[Transaction], Error>) -> Void) {
		self.client.fetchTransactions { (result) in
			DispatchQueue.main.async {
				switch result {
				case .success(let transactions):
					completion(.success(transactions))
				case .failure(let error):
					completion(.failure(error))
				}
			}
		}
	}

	func getAccounts(completion: @escaping (Result<[Account], Error>) -> Void) {
		self.client.fetchAccounts { (result) in
			DispatchQueue.main.async {
				switch result {
				case .success(let accounts):
					completion(.success(accounts))
				case .failure(let error):
					completion(.failure(error))
				}
			}
		}
	}
}
