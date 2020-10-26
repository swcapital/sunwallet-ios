import SwiftUI

struct AboutSection: View {
    // MARK:- Properties
    let asset: Asset
    
    @EnvironmentObject private var assetInfoStore: AssetInfoStore
    
    private var info: AssetInfo? { assetInfoStore.info(for: asset) }
    
    // MARK:- Subviews
    private var cellContent: some View {
        info.map { info in
            VStack {
                Button(action: {
                    if let url = URL(string: info.website) {
                       UIApplication.shared.open(url)
                   }
                }) {
                    HStack(spacing: 16) {
                        Image("website")
                        Text("Official website")
                            .foregroundColor(.primary)
                        Spacer()
                    }
                }
                .padding()
                
                Divider()
                
                Text(info.about)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding()
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
                
                cellContent
            }
        }
    }
}


struct AboutSection_Previews: PreviewProvider {
    static var previews: some View {
        AboutSection(asset: .btc)
    }
}
