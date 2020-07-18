import SwiftUI

struct RefferalView: View {
    
    // MARK:- Subviews
    private var copyButton: some View {
        Button(action: {}) {
            Text("copy")
        }
        .padding()
        .foregroundColor(.primary)
    }
    private var textFieldBorder: some View {
        RoundedRectangle(cornerRadius: 8)
            .stroke(Color.lightGray, lineWidth: 2)
    }
    private var mainImage: some View {
        Image("referrals")
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
    private var addressLabel: some View {
        Text("sunwallet.com/join/markl")
            .frame(height: 32)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(8)
            .background(textFieldBorder)
            .overlay(copyButton, alignment: .trailing)
    }
    private var inviteButton: some View {
        Button(action: {}) {
            Text("Invite from contacts")
        }
        .buttonStyle(PrimaryButtonStyle())
    }
    private var shareButton: some View {
        Button(action: {}) {
            Text("Share")
        }
        .buttonStyle(SecondaryButtonStyle())
    }
    private var termsButton: some View {
        Button(action: {}) {
            Text("Terms and conditions")
                .foregroundColor(.gray)
                .font(.headline)
        }
    }
    
    var body: some View {
        VStack(spacing: 16) {
            mainImage
            
            Text("Get 10$ in Bitcoin")
                .font(.title)
            
            Text("You'll both get 10$ in free Bitcoin when your friend buys or sells $100 of crypto.")
                .multilineTextAlignment(.center)
                .foregroundColor(.blueGray)
                .font(.body)
            
            addressLabel
            
            inviteButton
            
            shareButton
            
            termsButton
        }
        .padding()
    }
}

struct RefferalView_Previews: PreviewProvider {
    static var previews: some View {
        RefferalView()
    }
}
