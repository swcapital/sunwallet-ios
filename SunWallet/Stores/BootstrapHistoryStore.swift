import Combine
import Foundation

class BootstrapHistoryStore: ObservableObject {
    @Published
    private(set) var state: State = .none
    
    func loadIfNeeded() {
        guard case State.none = state else { return }
        
        let base = Asset(code: CurrencyStore.currentCode)
        let cancellable = CacheProxyHistoryRepository()
            .bootstrapHistory(base: base)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveValue: { value in
                    self.state = .loaded(value)
                }
            )
        state = .loading(cancellable)
    }
}

extension BootstrapHistoryStore {
    enum State {
        case none
        case loading(AnyCancellable)
        case loaded([TradePairHistory])
    }
}
