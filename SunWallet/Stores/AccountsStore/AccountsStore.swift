import Combine
import Foundation

typealias Accounts = [Account]

class AccountsStore: ObservableObject {
    private typealias Subject = CurrentValueSubject<Accounts?, Never>
    typealias Publisher = AnyPublisher<Accounts?, Never>
    
    private var cancellable: AnyCancellable?
    private var subject: Subject?
    
    let historyStore: HistoryStore
    let walletsHistoryStore: WalletsHistoryStore
    
    init(historyStore: HistoryStore, walletsHistoryStore: WalletsHistoryStore) {
        self.historyStore = historyStore
        self.walletsHistoryStore = walletsHistoryStore
    }
    
    var publisher: Publisher {
        if let subject = self.subject {
            return subject.eraseToAnyPublisher()
        } else {
            return makeSubject().eraseToAnyPublisher()
        }
    }
    
    private func makeSubject() -> Subject {
        let subject = Subject(nil)
        self.subject = subject
        
        cancellable = Publishers.CombineLatest(historyStore.publisher(for: .all), walletsHistoryStore.walletsHistoryPublisher)
            .sink(receiveValue: { (exchangeHistory, walletsHistory) in
                guard let exchangeHistory = exchangeHistory, let walletsHistory = walletsHistory else {
                    subject.send(nil)
                    return
                }
                let accounts = self.makeAccounts(walletsHistory: walletsHistory, exchangeHistory: exchangeHistory)
                subject.send(accounts)
                self.cancellable?.cancel()
            })
        
        return subject
    }
    
    private func makeAccounts(walletsHistory: WalletsHistory, exchangeHistory: [ExchangeHistory]) -> Accounts {
        walletsHistory.map {
            self.makeAccounts(walletHistory: $0, exchangeHistory: exchangeHistory)
        }
        .reduce([], +)
    }
    
    private func makeAccounts(walletHistory: WalletHistory, exchangeHistory: [ExchangeHistory]) -> Accounts {
        walletHistory.wallet.assets.compactMap { asset in
            guard let assetHistory = walletHistory.assetsHistory.first(where: { $0.asset == asset }) else { return nil }
            if let history = exchangeHistory.first(where: { $0.source == asset }) {
                let price = history.historySet.lastValue
                let balance = assetHistory.balance
                return Account(wallet: walletHistory.wallet, asset: asset, amount: balance, equity: price * balance, price: price)
            } else {
                print(asset)
                return Account(wallet: walletHistory.wallet, asset: asset, amount: 0, equity: 0, price: 0)
            }
        }
    }
}


private extension Wallet {
    
    var assets: [Asset] {
        [asset] + (asset == .eth ? Asset.etherTokens : [])
    }
}
