import Combine
import Foundation
import SwiftUI

class BlockchainStore: ObservableObject {
    private var balanceSubject: CurrentValueSubject<[Wallet: Double]?, Never>?
    private var cancellables: Set<AnyCancellable> = []
        
    let walletStore: WalletStore
        
    init(walletStore: WalletStore) {
        self.walletStore = walletStore
        
        subscribeOnWalletStore()
    }
    
    var walletsBalancePublisher: AnyPublisher<[Wallet: Double]?, Never> {
        if let subject = balanceSubject {
            return subject.eraseToAnyPublisher()
        } else {
            let subject = CurrentValueSubject<[Wallet: Double]?, Never>(nil)
            balanceSubject = subject
            updateWalletsBalanceSubject()
            return subject.eraseToAnyPublisher()
        }
    }
    
    func balances(wallets: [Wallet], completion: @escaping ([Wallet: Double]?) -> Void) {
        let blockchainRepository = BlockchainRepository()
        
        let publishers = wallets.map {
            blockchainRepository.balance(for: $0)
        }
        
        var cancellable: AnyCancellable?
        cancellable = Publishers.MergeMany(publishers)
            .collect()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { result in
                    switch result {
                    case .failure: completion(nil)
                    default: break
                    }
                    cancellable?.cancel()
                },
                receiveValue: { completion(Dictionary(uniqueKeysWithValues: zip(wallets, $0))) }
            )
    }
}

// MARK: - Publishers
extension BlockchainStore {
    
    private func updateWalletsBalanceSubject() {
        guard let subject = balanceSubject else { return }
        
        self.balances(wallets: walletStore.wallets) {
            subject.send($0)
        }
    }
    
    private func subscribeOnWalletStore() {
        walletStore.objectWillChange
            .sink(receiveValue: {
                self.updateWalletsBalanceSubject()
            })
            .store(in: &cancellables)
    }
}
