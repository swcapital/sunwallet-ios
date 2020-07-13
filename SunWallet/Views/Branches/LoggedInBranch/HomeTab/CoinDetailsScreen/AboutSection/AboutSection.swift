import SwiftUI

struct AboutSection: View {
    // MARK:- Properties
    let asset: Asset
    
    // MARK:- Subviews
    private var cellContent: some View {
        VStack(spacing: 16) {
            HStack(spacing: 16) {
                Image("website")
                Text("Official website")
                    .foregroundColor(.primaryBlue)
                Spacer()
            }
            HStack(spacing: 16) {
                Image("whitepaper")
                Text("Whitepaper")
                    .foregroundColor(.primaryBlue)
                Spacer()
            }
        }
    }
    
    var body: some View {
        Section {
            VStack(alignment: .leading, spacing: 8) {
                Text("About \(asset.title)")
                    .font(.title)
                    .bold()
                    .padding(.leading, 16)
                    .padding(.top, 32)
                
                Divider()
                
                Text("Fix Me")
                //Text(asset.about)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding()
                
                Divider()
                    .animation(nil)
                
                ExpandableCell(
                    header: { Text("Recources") },
                    content: { cellContent }
                )
                .padding(.horizontal, 16)
                
                Divider()
                    .animation(nil)
            }
        }
    }
}


struct AboutSection_Previews: PreviewProvider {
    static var previews: some View {
        AboutSection(asset: .btc)
    }
}
