import Combine
import Foundation
import SwiftUI

class BlockchainStore: ObservableObject {
    private typealias WalletsInfoSubject = CurrentValueSubject<[Wallet: WalletInfo]?, Never>
    typealias WalletsInfoPublisher = AnyPublisher<[Wallet: WalletInfo]?, Never>
    
    private var cancellables: Set<AnyCancellable> = []
    private var subject: WalletsInfoSubject?
    
    private let blockchainRepository: BlockchainRepository = BlockchairBlockchainRepository()
    private let cacheRepository: CacheRepository = FileCacheRepository()
    
    func walletsInfo(wallets: [Wallet], completion: @escaping ([Wallet: WalletInfo]?) -> Void) {
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
    
    func walletsInfoPublisher(wallets: [Wallet]) -> WalletsInfoPublisher {
        let subject = self.subject ?? WalletsInfoSubject(nil)
        self.subject = subject
        
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
        return subject.eraseToAnyPublisher()
    }
}

// MARK: - Publishers
extension BlockchainStore {
    
    private func _walletsInfoPublisher(wallets: [Wallet]) -> WalletsInfoPublisher {
        let publishers = wallets.map {
            blockchainRepository.balance(for: $0)
        }
        // TODO: Should be async.
        // MergeMany doesn't fit here - we loose an order
        return publishers.serialize()!
            .collect()
            .map { walletsInfoArray in
                let tuple = zip(wallets, walletsInfoArray)
                for (wallet, walletInfo) in tuple {
                    self.addCache(walletInfo: walletInfo, for: wallet)
                }
                return Dictionary(uniqueKeysWithValues: tuple)
            }
            .replaceError(with: nil)
            .eraseToAnyPublisher()
    }
}

// MARK: - Cache
extension BlockchainStore {
    
    private func anyCache(for wallets: [Wallet]) -> [Wallet: WalletInfo]? {
        guard let cache = blockchainCache() else { return nil }
        var result: [Wallet: WalletInfo] = [:]
        for wallet in wallets {
            guard let info = cache.get(for: wallet) else { continue }
            result[wallet] = info
        }
        return result
    }
    
    private func addCache(walletInfo: WalletInfo, for wallet: Wallet) {
        var cache = blockchainCache() ?? .init()
        cache.add(walletInfo, for: wallet)
        cacheRepository.save(cache, atKey: .blockchain)
    }
    
    private func freshCache(for wallets: [Wallet]) -> [Wallet: WalletInfo]? {
        guard let cache = blockchainCache() else { return nil }
        var result: [Wallet: WalletInfo] = [:]
        for wallet in wallets {
            guard let info = cache.get(for: wallet) else { return nil }
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
