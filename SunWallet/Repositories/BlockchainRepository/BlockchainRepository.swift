import Combine
import Foundation

protocol BlockchainRepository {
    func balance(for wallet: Wallet) -> AnyPublisher<WalletBalance, Error>
    func send(amount: Double, from account: Account, to address: String, privateKey: Data) -> AnyPublisher<Void, Error>
}
