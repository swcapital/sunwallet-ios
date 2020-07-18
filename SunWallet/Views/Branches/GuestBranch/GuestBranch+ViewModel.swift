import Combine
import Foundation

private let targets: [Asset] = [.btc, .bch, .eth, .init("etc"), .init("ltc")]

extension GuestBranch {
    class ViewModel: ObservableObject {
        @Published
        private(set) var state: State = .none
                
        func loadIfNeeded(currency: String) {
            guard case State.none = state else { return }
            
            let base = Asset(currency)
            let cancellable = CacheProxyHistoryRepository()
                .history(base: base, targets: targets)
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
