import Combine
import Foundation

class PortfolioStore: ObservableObject {
    private typealias WalletsHistorySubject = CurrentValueSubject<[Wallet: WalletHistory]?, Never>
    typealias WalletsHistoryPublisher = AnyPublisher<[Wallet: WalletHistory]?, Never>
    
    private var portfolioSubject: WalletsHistorySubject?
    private var portfolioSubscription: AnyCancellable?
    private var walletsSubscription: AnyCancellable?
    
    let historyStore: HistoryStore
    let blockchainStore: BlockchainStore
    let walletStore: WalletStore
    
    init(historyStore: HistoryStore, blockchainStore: BlockchainStore, walletStore: WalletStore) {
        self.historyStore = historyStore
        self.blockchainStore = blockchainStore
        self.walletStore = walletStore
        
        subscribeOnWalletStore()
    }
    
    var portfolioHistoryPublisher: WalletsHistoryPublisher {
        if let subject = portfolioSubject {
            return subject.eraseToAnyPublisher()
        } else {
            let subject = WalletsHistorySubject(nil)
            portfolioSubject = subject
            updatePortfolioHistorySubject()
            return subject.eraseToAnyPublisher()
        }
    }
    
    func walletsHistoryPublisher(wallets: [Wallet]) -> WalletsHistoryPublisher {
        let infoPublisher = blockchainStore.walletsInfoPublisher(wallets: wallets)
        let historyPublisher = historyStore.publisher(for: .mainPair)
        
        return Publishers.CombineLatest(infoPublisher, historyPublisher)
            .map { info, history -> [Wallet: WalletHistory]? in
                guard let info = info, let history = history else { return nil }
                return self.generateWalletsHistory(info: info, history: history)
            }
            .eraseToAnyPublisher()
    }
    
    func walletsHistory(wallets: [Wallet], completion: @escaping ([Wallet: WalletHistory]?) -> Void) {
        var cancellable: AnyCancellable?
        cancellable = walletsHistoryPublisher(wallets: wallets)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveValue: {
                    
                    completion($0)
                    cancellable?.cancel()
                }
            )
    }
    
    private func generateWalletsHistory(info: [Wallet : WalletInfo], history: [ExchangeHistory]) -> [Wallet: WalletHistory] {
        var result: [Wallet: WalletHistory] = [:]
        for (wallet, walletInfo) in info {
            guard let exchangeHistory = history.first(where: { $0.source == wallet.asset }) else { continue }
            result[wallet] = self.generateWalletHistory(walletInfo: walletInfo, historySet: exchangeHistory.historySet)
        }
        return result
    }
    
    private func generateWalletHistory(walletInfo: WalletInfo, historySet: HistorySet) -> WalletHistory {
        let userCurrencyBalance = historySet.lastValue * walletInfo.balance
        let balanceHistory = BalanceHistory(walletInfo: walletInfo)
        let convertedHistorySet = balanceHistory.converted(historySet: historySet)
        return .init(balance: walletInfo.balance, userCurrencyBalance: userCurrencyBalance, historySet: convertedHistorySet)
    }
}


// MARK: - Publishers
extension PortfolioStore {
    
    private func updatePortfolioHistorySubject() {
        guard let subject = portfolioSubject else { return }
        portfolioSubscription = walletsHistoryPublisher(wallets: walletStore.wallets).sink(receiveValue: { subject.send($0) })
    }
    
    private func subscribeOnWalletStore() {
        walletsSubscription = walletStore.objectWillChange.sink(receiveValue: { self.updatePortfolioHistorySubject() })
    }
}
