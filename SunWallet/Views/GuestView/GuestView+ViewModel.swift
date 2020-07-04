import Foundation
import Combine

extension GuestView {
    class ViewModel: ObservableObject {
        enum State {
            case loading
            case loaded([TradePairHistory])
            case error(String)
        }
        private var cancellable: AnyCancellable?
        
        @Published var state: State = .loading
        
        init() {
            DispatchQueue.main.asyncAfter(wallDeadline: .now() + 5, execute: load)
        }
        
        func load() {
            state = .loading
            let base = Asset(code: CurrencyStore.currentCode)
            cancellable = CacheProxyHistoryRepository()
                .bootstrapHistory(base: base)
                .receive(on: DispatchQueue.main)
                .sink(
                    receiveCompletion: { completion in
                        switch completion {
                        case .failure(let error):
                            self.state = .error(error.localizedDescription)
                        case .finished:
                            break
                        }
                    },
                    receiveValue: { value in
                        self.state = .loaded(value)
                    })
        }
    }
}
