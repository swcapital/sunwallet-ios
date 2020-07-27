import Combine
import Foundation

private let bootstrapTargets: [Asset] = [.btc, .bch, .eth, .init("etc"), .init("ltc")]

class HistoryStore: ObservableObject {
    private typealias HistorySubject = CurrentValueSubject<[ExchangeHistory]?, Never>
    typealias HistoryPublisher = AnyPublisher<[ExchangeHistory]?, Never>
    
    enum PublisherName: CaseIterable {
        case bootstrap
        case favorites
        case mainPair
    }
    
    private var cancellables: Set<AnyCancellable> = []
    private var subjects: [PublisherName: HistorySubject] = [:]
    
    private var userCurrencyAsset: Asset { .init(userSettingsStore.currency) }
    
    private let historyRepository: HistoryRepository = SunWalletHistoryRepository()
    private let cacheRepository: CacheRepository = FileCacheRepository()
    
    let userSettingsStore: UserSettingsStore
    
    init(userSettingsStore: UserSettingsStore) {
        self.userSettingsStore = userSettingsStore
        
        subscribeOnUserSettings()
    }
    
    func publisher(for name: PublisherName) -> HistoryPublisher {
        if let subject = subjects[name] {
            return subject.eraseToAnyPublisher()
        } else {
            return makeSubject(for: name).eraseToAnyPublisher()
        }
    }
}

// MARK: - Publishers
extension HistoryStore {
    
    private func makeSubject(for name: PublisherName) -> HistorySubject {
        let subject = HistorySubject(nil)
        subjects[name] = subject
        updateSubject(for: name)
        return subject
    }
    
    private func updateSubject(for name: PublisherName) {
        switch name {
        case .bootstrap:
            updateBootstrapHistorySubject()
        case .favorites:
            updateFavoritesHistorySubject()
        case .mainPair:
            updateMainPairHistorySubject()
        }
    }
    
    private func updateBootstrapHistorySubject() {
        guard let subject = self.subjects[.bootstrap] else { return }
        update(subject: subject, base: userCurrencyAsset, targets: bootstrapTargets, onError: bundleData())
    }
    
    private func updateFavoritesHistorySubject() {
        guard let subject = self.subjects[.favorites] else { return }
        update(subject: subject, base: userCurrencyAsset, targets: userSettingsStore.favorites)
    }
    
    private func updateMainPairHistorySubject() {
        guard let subject = self.subjects[.mainPair] else { return }
        update(subject: subject, base: userCurrencyAsset, targets: [.btc, .eth])
    }
    
    private func update(subject: HistorySubject, base: Asset, targets: [Asset], onError: [ExchangeHistory]? = nil) {
        if let cache = freshCache(base: base, targets: targets) {
            subject.send(cache)
        } else {
            if subject.value == nil {
                let cache = anyCache(base: base, targets: targets)
                subject.send(cache)
            }
            var cancellable: AnyCancellable?
            cancellable = historyPublisher(base: userCurrencyAsset, targets: userSettingsStore.favorites)
                .receive(on: DispatchQueue.main)
                .sink(
                    receiveValue: {
                        subject.send($0 ?? onError)
                        cancellable?.cancel()
                    }
                )
        }
    }
    
    private func historyPublisher(base: Asset, targets: [Asset]) -> AnyPublisher<[ExchangeHistory]?, Never> {
        historyRepository.history(base: base, targets: targets)
            .map { history -> [ExchangeHistory] in
                self.addCache(history)
                return history
            }
            .replaceError(with: anyCache(base: base, targets: targets))
            .eraseToAnyPublisher()
    }
    
    private func subscribeOnUserSettings() {
        userSettingsStore.objectWillChange
            .sink(receiveValue: {
                PublisherName.allCases.forEach { self.updateSubject(for: $0) }
            })
            .store(in: &cancellables)
    }
}

// MARK: - Cache
extension HistoryStore {
    
    private func anyCache(base: Asset, targets: [Asset]) -> [ExchangeHistory]? {
        return historyCache()?.get(base: base, targets: targets).compactMap { $0 }
    }
    
    private func freshCache(base: Asset, targets: [Asset]) -> [ExchangeHistory]? {
        guard let cache = historyCache() else { return nil }
        let history = cache.get(base: base, targets: targets, maxAge: 60 * 5).compactMap { $0 }
        guard targets.count == history.count else { return nil }
        return history
    }
    
    private func addCache(_ history: [ExchangeHistory]) {
        var cache = historyCache() ?? .init()
        cache.add(history)
        cacheRepository.save(cache, atKey: .history)
    }
    
    private func historyCache() -> HistoryCache? {
        cacheRepository.load(atKey: .history)
    }
    
    private func bundleData() -> [ExchangeHistory] {
        let url = Bundle.main.url(forResource: "bootstrap", withExtension: "json")!
        let data = try! Data(contentsOf: url)
        return (try? JSONDecoder().decode([ExchangeHistory].self, from: data)) ?? []
    }
}

private extension CacheKey {
    static let history = CacheKey(value: "history")
}
