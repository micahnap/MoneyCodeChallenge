import Foundation

struct Accounts: Decodable {
	let accounts: [Account]
}

struct Transactions: Decodable {
	var transactions: [Transaction]
}

struct Account: Decodable {
	let id: Int
	let name: String
	let balance: Double
	let available_balance: Double
	let currency: String
}

struct Transaction: Decodable {
	struct Address: Decodable {
		let address: String?
		let city: String?
		let region: String?
		let country: String?
		let postcode: String?
		let latitude: Decimal?
		let longitude: Decimal?
	}
	struct Merchant: Decodable {
		let name: String
		let address: Address?
		let updated: Date?
	}

	let id: String
	let created: Date
	let description: String
	let amount: Int
	let currency: String
	let merchant: Merchant
	let amount_is_pending: Bool
}

struct AccountClient {
	func fetchTransactions(result: @escaping (Result<[Transaction], Error>) -> Void) {
		guard let url = URL(string: "https://jsonstorage.net/api/items/7a8a340d-b450-4adc-bbba-f6b4c8cdbc09") else {
			let error = NSError(domain: "error", code: 0, userInfo: nil)
            result(.failure(error))
			return
		}

		URLSession.shared.dataTask(with: url) { data, _, error in
			if let error = error {
				result(.failure(error))
			}
			if let data = data {
				let decoder = JSONDecoder()
				decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
				do {
					let transactionData = try decoder.decode(Transactions.self, from: data)
					result(.success(transactionData.transactions))
				} catch (let error) {
					result(.failure(error))
				}
			}
		}.resume()
	}

	let defaultSession = URLSession(configuration: .default)
	private var dataTask: URLSessionDataTask?

	func fetchAccounts(result: @escaping (Result<[Account], Error>) -> Void) {
		guard let url = URL(string: "https://jsonstorage.net/api/items/d97f27b5-caba-4cc8-9f5d-32b0208ec7f0") else {
			let error = NSError(domain: "error", code: 0, userInfo: nil)
            result(.failure(error))
			return
		}

		URLSession.shared.dataTask(with: url) { data, _, error in
			if let error = error {
				result(.failure(error))
			}
			if let data = data {
				let decoder = JSONDecoder()
				do {
					let accountData = try decoder.decode(Accounts.self, from: data)
					result(.success(accountData.accounts))
				} catch (let error) {
					result(.failure(error))
				}
			}
		}.resume()
	}
}

extension DateFormatter {
  static let iso8601Full: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
    formatter.calendar = Calendar(identifier: .iso8601)
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    formatter.locale = Locale(identifier: "en_US_POSIX")
    return formatter
  }()
}
