import Foundation

struct BalanceHistory {
    private let historyValues: [HistoryValue]
    
    init(walletInfo: WalletInfo) {
        var currentBalance = walletInfo.balance
        self.historyValues = walletInfo.transactions
            .reversed()
            .map { transaction -> HistoryValue in
                currentBalance -= transaction.value
                return HistoryValue(date: transaction.date, value: currentBalance)
            }
            .reversed()
    }
    
    func converted(historySet: HistorySet) -> HistorySet {
        .init(
            hourly: converted(historyValues: historySet.hourly),
            daily: converted(historyValues: historySet.hourly),
            weekly: converted(historyValues: historySet.hourly),
            monthly: converted(historyValues: historySet.hourly),
            yearly: converted(historyValues: historySet.hourly),
            all: converted(historyValues: historySet.hourly)
        )
    }
    
    private func balance(at date: Date) -> Double {
        //TODO: - Need test
        historyValues.first(where: { date > $0.date })?.value ?? 0
    }
    
    private func converted(historyValues: [HistoryValue]) -> [HistoryValue] {
        historyValues.map {
            HistoryValue(date: $0.date, value: balance(at: $0.date) * $0.value)
        }
    }
}
