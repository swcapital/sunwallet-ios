import Combine
import Foundation
import TrustWalletCore

typealias WalletsBalance = [WalletBalance]

class BlockchainStore: ObservableObject {
    private typealias WalletsBalanceSubject = CurrentValueSubject<WalletsBalance?, Never>
    typealias WalletsBalancePublisher = AnyPublisher<WalletsBalance?, Never>
    
    private var cancellables: Set<AnyCancellable> = []
    private var subjects: [[Wallet]: WalletsBalanceSubject] = [:]
    
    private let blockchainRepository: BlockchainRepository = AmberdataBlockchainRepository()
    private let cacheRepository: CacheRepository = FileCacheRepository()
    
    let walletStore: WalletStore
    
    init(walletStore: WalletStore) {
        self.walletStore = walletStore
    }
    
    func walletsInfo(wallets: [Wallet], completion: @escaping (WalletsBalance?) -> Void) {
        var cancellable: AnyCancellable?
        cancellable = walletsInfoPublisher(wallets: wallets)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveValue: {
                    completion($0)
                    cancellable?.cancel()
                }
            )
    }
    
    func walletsInfoPublisher(wallets: [Wallet]) -> WalletsBalancePublisher {
        if let subject = subjects[wallets] {
            return subject.eraseToAnyPublisher()
        } else {
            return makeSubject(for: wallets).eraseToAnyPublisher()
        }
    }
    
    func send(amount: Double, from account: Account, to destination: String) -> AnyPublisher<Void, Error>  {
        let privateKey = walletStore.privateKey(for: account.wallet)!
        return blockchainRepository.send(amount: amount, from: account, to: destination, privateKey: privateKey)
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    private func makeSubject(for wallets: [Wallet]) -> WalletsBalanceSubject {
        let subject = WalletsBalanceSubject(nil)
        subjects[wallets] = subject
        
        if let cache = freshCache(for: wallets) {
            subject.send(cache)
        } else {
            if subject.value == nil {
                let cache = anyCache(for: wallets)
                subject.send(cache)
            }
            var cancellable: AnyCancellable?
            cancellable = _walletsInfoPublisher(wallets: wallets)
                .receive(on: DispatchQueue.main)
                .sink(
                    receiveValue: {
                        subject.send($0)
                        cancellable?.cancel()
                    }
                )
        }
        return subject
    }
}

// MARK: - Publishers
extension BlockchainStore {
    
    private func _walletsInfoPublisher(wallets: [Wallet]) -> WalletsBalancePublisher {
        let publishers = wallets.enumerated().map {
            blockchainRepository.balance(for: $0.element)
                .delay(for: .milliseconds(500 * $0.offset), scheduler: DispatchQueue.global())
        }
        return Publishers.MergeMany(publishers)
            .collect()
            .map { walletsBalance in
                walletsBalance.forEach { self.addCache($0) }
                return walletsBalance
            }
            .replaceError(with: nil)
            .eraseToAnyPublisher()
    }
}

// MARK: - Cache
extension BlockchainStore {
    
    private func anyCache(for wallets: [Wallet]) -> WalletsBalance? {
        guard let cache = blockchainCache() else { return nil }
        return wallets.compactMap { cache.get(for: $0) }
    }
    
    private func addCache(_ walletBalance: WalletBalance) {
        var cache = blockchainCache() ?? .init()
        cache.add(walletBalance, for: walletBalance.wallet)
        cacheRepository.save(cache, atKey: .blockchain)
    }
    
    private func freshCache(for wallets: [Wallet]) -> WalletsBalance? {
        guard let cache = blockchainCache() else { return nil }
        let result = wallets.compactMap { cache.get(for: $0, maxAge: 60 * 5) }
        guard result.count == wallets.count else { return nil }
        return result
    }
    
    private func blockchainCache() -> BlockchainCache? {
        cacheRepository.load(atKey: .blockchain)
    }
}

private extension CacheKey {
    static let blockchain = CacheKey(value: "blockchain")
}

extension Collection where Element: Publisher {
    
    func serialize() -> AnyPublisher<Element.Output, Element.Failure>? {
        guard let start = self.first else { return nil }
        return self.dropFirst().reduce(start.eraseToAnyPublisher()) {
            $0.append($1).eraseToAnyPublisher()
        }
    }
}
