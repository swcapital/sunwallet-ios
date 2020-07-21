import Combine

protocol BlockchainRepository {
    func balance(for wallet: Wallet) -> AnyPublisher<Double, Error>
}
