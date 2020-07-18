import Combine
import Foundation

class HistoryStore: ObservableObject {
    private var cancalables: Set<AnyCancellable> = []
    
    @Published
    private(set) var favorites: [ExchangeHistory] { didSet { objectWillChange.send() } }
    
    let objectWillChange = PassthroughSubject<Void, Never>()
    
    let userSettingsStore: UserSettingsStore
    
    private var userCurrencyAsset: Asset { .init(userSettingsStore.currency) }
    
    init(userSettingsStore: UserSettingsStore) {
        self.userSettingsStore = userSettingsStore
        self.favorites = []
        self.favorites = CacheProxyHistoryRepository().cachedData(base: self.userCurrencyAsset, targets: userSettingsStore.favorites)
        
        subscribeOnUserSettings()
        refreshFavorites()
    }
    
    func subscribeOnUserSettings() {
        userSettingsStore.objectWillChange
            .sink(receiveValue: { self.refreshFavorites() })
            .store(in: &cancalables)
    }
    
    func refreshFavorites() {
        CacheProxyHistoryRepository()
            .history(base: userCurrencyAsset, targets: userSettingsStore.favorites)
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { self.favorites = $0 })
            .store(in: &cancalables)
    }
}
