import SwiftUI

struct HomeArticleCell: View {
    // MARK:- Properties
    let article: Article
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(article.title)
                    .bold()
                    .fixedSize(horizontal: false, vertical: true)
                
                Text("\(article.source) · \(article.date)")
                    .foregroundColor(.gray)
                    .padding(.vertical, 4)
                    .font(.footnote)
                
                article.tag.map { tag in
                    HStack {
                        Circle()
                            .fill(Color.orange)
                            .frame(width: 10)
                        Text(tag)
                    }
                }
                Spacer()
            }
            
            article.imageName.map {
                Image($0)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 50, height: 50)
                    .cornerRadius(4)
            }
        }
        .padding(.horizontal, 16)
    }
}
