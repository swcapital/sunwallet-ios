import SwiftUI

struct PreferenceCell: View {
    // MARK:- Properties
    let title: String
    let subtitle: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
                .fontWeight(.regular)
                .frame(height: 20.0)
            
            Spacer()
            
            Text(subtitle)
                .fontWeight(.regular)
                .foregroundColor(Color.gray)
                .font(.headline)
            
            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
            
        }
        .padding()
    }
}
