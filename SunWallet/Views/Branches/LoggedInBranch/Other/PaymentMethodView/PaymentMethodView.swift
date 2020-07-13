import SwiftUI

struct PaymentMethodView: View {
    
    // MARK:- Subviews
    private var cardPaymentCell: some View {
        NavigationLink(destination: Text("Hello")) {
            PaymentMethodCell(
                imageName: "credit-card",
                title: Text("Credit/Debit card"),
                subtitle: Text("Invest small amounts").foregroundColor(.blueGray),
                text: Text("Use any Visa or Mastercard to make small investments. Add a bank or wallet to sell.")
            )
        }
    }
    private var paypalPaymentCell: some View {
        NavigationLink(destination: Text("PayPal")) {
            PaymentMethodCell(
                imageName: "paypal",
                title: Text("PayPal"),
                subtitle: Text("For withdrawals only").foregroundColor(.blueGray),
                text: Text("Link your account to instantly withdraw funds from Sunwalet to PayPal. Deposits are not currently available.")
            )
        }
    }
    private var bankPaymentCell: some View {
        NavigationLink(destination: Text("Bank")) {
            PaymentMethodCell(
                imageName: "bank-account",
                title: Text("Euro Bank Account"),
                subtitle: Text("Invest large amounts").foregroundColor(.green),
                text: Text("Add any bank account that can make and accept SEPA payments. Once completed, you can instantly buy and")
            )
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    Text("Add a payment method")
                        .font(.title)
                        .padding(.horizontal)
                    
                    Divider()
                    
                    cardPaymentCell
                    
                    Divider()
                    
                    paypalPaymentCell
                    
                    Divider()
                    
                    bankPaymentCell
                    
                    Divider()
                }
            }
            .accentColor(.black)
        }
    }
}

struct PaymentMethodView_Previews: PreviewProvider {
    static var previews: some View {
        PaymentMethodView()
    }
}
