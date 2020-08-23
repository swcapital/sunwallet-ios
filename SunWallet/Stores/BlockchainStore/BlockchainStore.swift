import Combine
import Foundation

class BlockchainStore: ObservableObject {
    private typealias WalletsBalanceSubject = CurrentValueSubject<[Wallet: WalletBalance]?, Never>
    typealias WalletsBalancePublisher = AnyPublisher<[Wallet: WalletBalance]?, Never>
    
    private var cancellables: Set<AnyCancellable> = []
    private var subjects: [[Wallet]: WalletsBalanceSubject] = [:]
    
    private let blockchainRepository: BlockchainRepository = CryptoapisBlockchainRepository()
    private let cacheRepository: CacheRepository = FileCacheRepository()
    
    func walletsInfo(wallets: [Wallet], completion: @escaping ([Wallet: WalletBalance]?) -> Void) {
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
        let publishers = wallets.map {
            blockchainRepository.balance(for: $0)
        }
        // TODO: Should be async.
        // MergeMany doesn't fit here - we loose an order
        return publishers.serialize()!
            .collect()
            .map { walletsBalance in
                let tuple = zip(wallets, walletsBalance)
                for (wallet, walletBalance) in tuple {
                    self.addCache(walletBalance, for: wallet)
                }
                return Dictionary(uniqueKeysWithValues: tuple)
            }
            .replaceError(with: nil)
            .eraseToAnyPublisher()
    }
}

// MARK: - Cache
extension BlockchainStore {
    
    private func anyCache(for wallets: [Wallet]) -> [Wallet: WalletBalance]? {
        guard let cache = blockchainCache() else { return nil }
        var result: [Wallet: WalletBalance] = [:]
        for wallet in wallets {
            guard let info = cache.get(for: wallet) else { continue }
            result[wallet] = info
        }
        return result
    }
    
    private func addCache(_ walletBalance: WalletBalance, for wallet: Wallet) {
        var cache = blockchainCache() ?? .init()
        cache.add(walletBalance, for: wallet)
        cacheRepository.save(cache, atKey: .blockchain)
    }
    
    private func freshCache(for wallets: [Wallet]) -> [Wallet: WalletBalance]? {
        guard let cache = blockchainCache() else { return nil }
        var result: [Wallet: WalletBalance] = [:]
        for wallet in wallets {
            guard let info = cache.get(for: wallet, maxAge: 60 * 5) else { return nil }
            result[wallet] = info
        }
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
