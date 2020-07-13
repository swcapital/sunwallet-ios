import Combine
import Foundation

private let targets: [Asset] = [.btc, .bch, .eth, .init("etc"), .init("ltc")]

extension GuestBranch {
    class ViewModel: ObservableObject {
        @Published
        private(set) var state: State = .none
        
        private let userSettingsStore: UserSettingsStore = .init()
        
        func loadIfNeeded() {
            guard case State.none = state else { return }
            
            let cancellable = CacheProxyHistoryRepository()
                .history(base: userSettingsStore.userCurrency, targets: targets)
                .receive(on: DispatchQueue.main)
                .sink(
                    receiveValue: { value in
                        print(value)
                        self.state = .loaded(value)
                    }
                )
            state = .loading(cancellable)
        }
    }
}

extension GuestBranch.ViewModel {
    enum State {
        case none
        case loading(AnyCancellable)
        case loaded([ExchangeHistory])
    }
}
