import SwiftUI

private enum InputCurrency {
    case crypto, user
}

struct SendAssetScreen: View {
    @EnvironmentObject var userSettingsStore: UserSettingsStore
    
    let accounts: [Account]
    
    init(accounts: [Account]) {
        self.accounts = accounts
        self._selectedAccount = .init(initialValue: accounts.first!)
    }
    
    // MARK:- States
    @State private var selectedAccount: Account
    @State private var keyboardNumber: KeyboardNumber = .init()
    @State private var showAccountsView = false
    @State private var inputCurrency: InputCurrency = .user

    // MARK:- Calculated Variables
    private var userCurrencyAmount: Double {
        switch inputCurrency {
        case .user: return keyboardNumber.doubleValue
        case .crypto: return keyboardNumber.doubleValue * selectedAccount.price
        }
    }
    private var cryptoAmount: Double {
        switch inputCurrency {
        case .user: return keyboardNumber.doubleValue / selectedAccount.price
        case .crypto: return keyboardNumber.doubleValue
        }
    }
    private var isNextButtonEnabled: Bool {
        print(keyboardNumber.doubleValue)
        print(cryptoAmount)
        print(selectedAccount.amount)
        return (keyboardNumber.doubleValue != 0) && (cryptoAmount <= selectedAccount.amount)
    }
    private var selectedAccountProxy: Binding<Account?> {
        .init(
            get: { self.selectedAccount },
            set: { newValue in
                withAnimation {
                    self.showAccountsView = false
                    if let newValue = newValue {
                        self.selectedAccount = newValue
                    }
                }
            }
        )
    }
    var currentAssetCode: String {
        selectedAccount.asset.code.uppercased()
    }
    
    // MARK:- Subviews
    private var accountsView: some View {
        BottomSheetView(isOpen: $showAccountsView) {
            AccountPickerView(accounts: accounts, selectedAccount: selectedAccountProxy)
                .frame(height: 300)
                .frame(maxWidth: .infinity)
        }
    }
    private var nextButton: some View {
        NavigationLink(
            "Next",
            destination: SendingDesinationScreen(
                account: selectedAccount,
                amount: .init(crypto: cryptoAmount, user: userCurrencyAmount)
            )
        )
        .disabled(!isNextButtonEnabled)
        .buttonStyle(PrimaryButtonStyle())
        .padding()
    }
    private var content: some View {
        VStack {
            Spacer()
            
            inputView
            
            Spacer()
            
            changeAccountButton
                .padding()
            
            Keyboard(keyboardNumber: $keyboardNumber)
            
            nextButton
        }
    }
    private var changeAccountButton: some View {
        Button(animationAction: { self.showAccountsView = true }) {
            AccountCell(account: selectedAccount)
                .padding(.horizontal)
                .roundedBorder()
        }
    }
    private var currentCurrencyLabel: some View {
        let string: String
        switch inputCurrency {
        case .crypto: string = currentAssetCode
        case .user: string = userSettingsStore.currency
        }
        return Text(string)
            .font(.headline)
            .foregroundColor(.secondary)
    }
    private var alternateCurrencyLabel: some View {
        let string: String
        switch inputCurrency {
        case .user:
            let convertedAmount = keyboardNumber.doubleValue / selectedAccount.price
            string = convertedAmount.currencyString(code: currentAssetCode)
        case .crypto:
            let convertedAmount = keyboardNumber.doubleValue * selectedAccount.price
            string = convertedAmount.currencyString(code: userSettingsStore.currency)
        }
        return Text(string)
            .font(.caption)
            .foregroundColor(.secondary)
    }
    private var maxButton: some View {
        Button(action: useMaxAmount) {
            CircleIcon(radius: 40) { Text("MAX").font(.caption) }
        }
    }
    private var switchCurrencyButton: some View {
        Button(action: exchangeInput) {
            CircleIcon(radius: 40) { Image(systemName: "arrow.up.arrow.down") }
        }
    }
    private var amountLabel: some View {
        Text(keyboardNumber.stringValue)
            .font(.largeTitle)
    }
    private var inputView: some View {
        VStack {
            currentCurrencyLabel
            
            HStack {
                maxButton
                
                amountLabel
                    .frame(width: 120)
                    .lineLimit(1)
                    .minimumScaleFactor(0.3)
                
                switchCurrencyButton
            }
            
            alternateCurrencyLabel
        }
    }

    var body: some View {
        ZStack {
            content
                .padding(.vertical)
                .zIndex(0) // Needed for animation

            if showAccountsView {
                accountsView
            }
        }
    }

    // MARK:- Methods
    private func onChangeDirection() {
        withAnimation {
            self.showAccountsView.toggle()
        }
    }
    
    private func exchangeInput() {
        switch inputCurrency {
        case .user:
            keyboardNumber.doubleValue /= selectedAccount.price
            inputCurrency = .crypto
        case .crypto:
            keyboardNumber.doubleValue *= selectedAccount.price
            inputCurrency = .user
        }
    }
    
    private func useMaxAmount() {
        switch inputCurrency {
        case .crypto:
            keyboardNumber.doubleValue = selectedAccount.amount
        case .user:
            keyboardNumber.doubleValue =  selectedAccount.amount * selectedAccount.price
        }
    }
}
