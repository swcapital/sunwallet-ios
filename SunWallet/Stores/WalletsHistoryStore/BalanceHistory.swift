import Foundation

struct BalanceHistory {
    private let historyValues: [HistoryValue]
    
    init(assetInfo: AssetBalance) {
        var currentBalance = assetInfo.balance
        let transactionValues = assetInfo.transactions
            .reversed()
            .map { transaction -> HistoryValue in
                defer { currentBalance -= transaction.value }
                return HistoryValue(date: transaction.date, value: currentBalance)
            }
            .reversed()
        let initialValue = HistoryValue(date: Date(timeIntervalSince1970: 0), value: currentBalance)
        self.historyValues = [initialValue] + transactionValues
    }
    
    func converted(historySet: HistorySet) -> HistorySet {
        .init(
            hourly: converted(historyValues: historySet.hourly),
            daily: converted(historyValues: historySet.daily),
            weekly: converted(historyValues: historySet.weekly),
            monthly: converted(historyValues: historySet.monthly),
            yearly: converted(historyValues: historySet.yearly),
            all: converted(historyValues: historySet.all)
        )
    }
    
    func balance(at date: Date) -> Double {
        historyValues.last(where: { date > $0.date })?.value ?? 0
    }
    
    private func converted(historyValues: [HistoryValue]) -> [HistoryValue] {
        historyValues.map {
            HistoryValue(date: $0.date, value: balance(at: $0.date) * $0.value)
        }
    }
}
