import Combine
import Foundation

class HistoryStore: ObservableObject {
    private var cancellables: Set<AnyCancellable> = []
    private var userCurrencyAsset: Asset { .init(userSettingsStore.currency) }
    
    let userSettingsStore: UserSettingsStore
    
    @Published
    var favorites: [ExchangeHistory]
    
    init(userSettingsStore: UserSettingsStore) {
        self.userSettingsStore = userSettingsStore
        self.favorites = []
        //self.favorites = CacheProxyHistoryRepository().cachedData(base: self.userCurrencyAsset, targets: userSettingsStore.favorites)
        
        //subscribeOnUserSettings()
        //refreshFavorites()
    }
    
    func subscribeOnUserSettings() {
        userSettingsStore.objectWillChange
            .sink(receiveValue: { self.refreshFavorites() })
            .store(in: &cancellables)
    }
    
    func refreshFavorites() {
        CacheProxyHistoryRepository()
            .history(base: userCurrencyAsset, targets: userSettingsStore.favorites)
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { self.favorites = $0 })
            .store(in: &cancellables)
    }
    
    func history(base: Asset, targets: [Asset], completion: @escaping ([ExchangeHistory]) -> Void) {
        CacheProxyHistoryRepository()
            .history(base: base, targets: targets)
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { completion($0) })
            .store(in: &cancellables)
    }
    
    func history(targets: [Asset], completion: @escaping ([ExchangeHistory]) -> Void) {
        history(base: userCurrencyAsset, targets: targets, completion: completion)
    }
}
