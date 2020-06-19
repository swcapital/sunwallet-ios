import SwiftUI

struct PromoteSection: View {
    
    // MARK:- Subviews
    private var header: some View {
        Text("Do More With Crypto")
            .font(.title)
            .padding(16)
    }
    private var overlay: some View {
        RoundedRectangle(cornerRadius: 8)
            .stroke(Color.lightGray, lineWidth: 0.5)
    }
    
    var body: some View {
        Section(header: header) {
            ScrollView(.horizontal,showsIndicators: false) {
                HStack(spacing: 15) {
                    VStack(alignment: .leading) {
                        Text("Earn rewards")
                            .padding(16)
                            .foregroundColor(.primaryBlue)
                        Text("Invate to friend to SunWallet and you'll both get $10")
                            .padding(.horizontal, 16)
                        Image("referrals")
                            .renderingMode(.original)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: .infinity)
                        
                    }
                    .overlay(overlay)
                    .frame(width: 380, height: 280)
                    .padding(.all, 1)
                }
                .padding(.top, 10)
                .padding(.leading, 16)
            }
        }
    }
}
